#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  #Pragma BackgroundTasks False
		  #Pragma StackOverflowChecking False
		  #Pragma BoundsChecking False
		  #Pragma NilObjectChecking False
		  #Pragma Debugging False
		  
		  Var Ranges() As String
		  Try
		    Ranges = Read(args(1)).ToArray(",")
		  Catch
		    Print("Error reading input file.")
		    Return 0
		  End Try
		  
		  Var SumTwice, SumAtLeastTwice, Sum1, Sum2 As Int64
		  For Each Range As String In Ranges
		    Var Parts() As String = Range.ToArray("-")
		    SumInvalidIDs(Parts(0).ToInt64, Parts(1).ToInt64, Sum1, Sum2)
		    SumTwice = SumTwice + Sum1
		    SumAtLeastTwice = SumAtLeastTwice + Sum2
		  Next
		  
		  Print("Sum of invalid IDs with pattern repeated twice: " + SumTwice.ToString)
		  Print("Sum of invalid IDs with pattern repeated at least twice: " + SumAtLeastTwice.ToString)
		  Return 0
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function Read(name As String) As String
		  Var Stream As TextInputStream = TextInputStream.Open(New FolderItem(name))
		  Var Content As String = Stream.ReadAll.ReplaceLineEndings("").ReplaceAll(" ", "").Trim
		  Stream.Close
		  Return Content
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SumInvalidIDs(startValue As Int64, endValue As Int64, ByRef sumTwice As Int64, ByRef sumAtLeastTwice As Int64)
		  #Pragma BackgroundTasks False
		  #Pragma StackOverflowChecking False
		  #Pragma BoundsChecking False
		  #Pragma NilObjectChecking False
		  #Pragma Debugging False
		  
		  Var r1 As New RegEx, r2 As New RegEx
		  r1.SearchPattern = "^(\d+)\1$"
		  r2.SearchPattern = "^(\d+)\1{1,}$"
		  
		  sumTwice = 0
		  sumAtLeastTwice = 0
		  
		  Var ValueString As String
		  For Value As Int64 = startValue to endValue
		    ValueString = Value.ToString
		    If r2.Search(ValueString) <> Nil Then
		      sumAtLeastTwice = sumAtLeastTwice + Value
		      If r1.Search(ValueString) <> Nil Then
		        sumTwice = sumTwice + Value
		      End If
		    End If
		  Next
		End Sub
	#tag EndMethod


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
