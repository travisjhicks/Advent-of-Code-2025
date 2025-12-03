#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // Open file specified in first argument
		  Var Stream As TextInputStream
		  Try
		    Stream = TextInputStream.Open(New FolderItem(args(1)))
		  Catch
		    Print("Error reading input file.")
		    Return 0
		  End Try
		  
		  // Find max joltage
		  Var Sum2, Sum12 As UInt64
		  Var Line As String
		  While Not Stream.EndOfFile
		    Line = Stream.ReadLine.Trim
		    Sum2 = Sum2 + MaxJoltage(Line, 2)
		    Sum12 = Sum12 + MaxJoltage(Line, 12)
		  Wend
		  
		  // Close file and show result
		  Stream.Close
		  Print("Max joltage for 2 batteries: " + Sum2.ToString)
		  Print("Max joltage for 12 batteries: " + Sum12.ToString)
		  Return 0
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function MaxDigit(value As String) As Integer
		  Var m As Integer
		  For Each Character As String In value.Characters
		    m = Max(m, Character.ToInteger)
		    If m = 9 Then Exit
		  Next
		  Return m
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MaxJoltage(bank As String, count As Integer) As UInt64
		  Var Joltage As UInt64
		  Var NextDigit As Integer
		  For Index As Integer = 0 To Count - 1
		    NextDigit = MaxDigit(bank.Left(bank.Length - (Count - 1 - Index)))
		    bank = bank.Middle(bank.IndexOf(NextDigit.ToString) + 1)
		    Joltage = Joltage * 10 + NextDigit
		  Next
		  Return Joltage
		End Function
	#tag EndMethod


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
