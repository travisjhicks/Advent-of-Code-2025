#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  ///// PART 1 /////
		  
		  // Read file into Cells(Row, Column)
		  Try
		    ReadFile(args(1))
		  Catch
		    Print("Error reading input file.")
		    Return 0
		  End Try
		  
		  Var Sum As UInt64
		  For Column As Integer = 0 To Cells.LastIndex(2)
		    Sum = Sum + ComputeColumn(Column)
		  Next
		  
		  Print("Part One Sum: " + Sum.ToString)
		  
		  Return 0
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function ComputeColumn(column As Integer) As UInt64
		  Var Operator As String = Cells(Cells.LastIndex(1), column)
		  Var Value As UInt64 = Cells(0, column).ToInt64
		  For Row As Integer = 1 To Cells.LastIndex(1) - 1
		    Select Case Operator
		    Case "+"
		      Value = Value + Cells(Row, column).ToInt64
		    Case "*"
		      Value = Value * Cells(Row, column).ToInt64
		    End Select
		  Next
		  Return Value
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ReadFile(name As String)
		  Var Stream As TextInputStream = TextInputStream.Open(New FolderItem(name))
		  While Not Stream.EndOfFile
		    Var Line As String = Stream.ReadLine.Trim
		    While Line.Contains("  ")
		      Line = Line.ReplaceAll("  ", " ")
		    Wend
		    Var Elements() As String = Line.ToArray(" ")
		    Cells.ResizeTo(Cells.LastIndex(1) + 1, Max(Cells.LastIndex(2), Elements.LastIndex))
		    For Index As Integer = 0 To Elements.LastIndex
		      Cells(Cells.LastIndex(1), Index) = Elements(Index)
		    Next
		  Wend
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Cells(-1,-1) As String
	#tag EndProperty


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
