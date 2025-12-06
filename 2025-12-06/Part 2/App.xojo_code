#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  ///// PART 2 /////
		  
		  // Read file into array of lines
		  Try
		    Var Stream As TextInputStream = TextInputStream.Open(New FolderItem(args(1)))
		    While Not Stream.EndOfFile
		      Lines.Add(Stream.ReadLine)
		    Wend
		    Stream.Close
		  Catch
		    Print("Error reading input file.")
		    Return 0
		  End Try
		  
		  // Confirm lines are the same length
		  For Index As Integer = 0 To Lines.LastIndex - 1
		    If Lines(Index).Length <> Lines(Index + 1).Length Then
		      Print("Lines must be the same length.")
		      Return 0
		    End If
		  Next
		  
		  // Process left to right
		  // Should be using a state machine here but let's just rely on formatting consistency for the operator alignment
		  Var Operands() As UInt64
		  Var Operator As String
		  Var Sum As UInt64
		  For Column As Integer = Lines(0).Length - 1 DownTo 0
		    If ColumnBlank(Column) Then Continue
		    Operands.Add(ColumnNumber(Column))
		    Operator = ColumnOperator(Column)
		    If Operator <> "" Then
		      Sum = Sum + Calculate(Operands, Operator)
		      Operands.RemoveAll
		    End If
		  Next
		  
		  Print("Part Two Sum: " + Sum.ToString)
		  Return 0
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function Calculate(operands() As UInt64, operator As String) As UInt64
		  Var Value As UInt64 = operands(0)
		  For Index As Integer = 1 To operands.LastIndex
		    Select Case operator
		    Case "+"
		      Value = Value + operands(Index)
		    Case "*"
		      Value = Value * operands(Index)
		    End Select
		  Next
		  Return Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ColumnBlank(column As Integer) As Boolean
		  For Row As Integer = 0 To Lines.LastIndex
		    If Lines(Row).Middle(column, 1).Trim <> "" Then Return False
		  Next
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ColumnNumber(column As Integer) As UInt64
		  Var Number As UInt64
		  For Row As Integer = 0 To Lines.LastIndex - 1
		    Var Char As String = Lines(Row).Middle(column, 1)
		    If Char = " " Then Continue
		    Number = Number * 10 + Char.ToInteger
		  Next
		  Return Number   
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ColumnOperator(column As Integer) As String
		  Return Lines(Lines.LastIndex).Middle(column, 1).Trim
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Lines() As String
	#tag EndProperty


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
