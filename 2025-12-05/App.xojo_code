#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // Open file for reading
		  Var Stream As TextInputStream
		  Try
		    Stream = TextInputStream.Open(New FolderItem(args(1)))
		  Catch
		    Print("Error reading input file.")
		    Return 0
		  End Try
		  
		  ///// PART 1 /////
		  
		  // Read fresh ID ranges until the blank line
		  Var FreshRanges() As Pair
		  While Not Stream.EndOfFile
		    Var Line() As String = Stream.ReadLine.Trim.ToArray("-")
		    If Line.Count <> 2 Then Exit
		    FreshRanges.Add(Line(0).ToInt64 : Line(1).ToInt64)
		  Wend
		  
		  // Read available ingredient IDs and count how many are in the fresh ranges
		  Var AvailableFreshCount As Integer
		  While Not Stream.EndOfFile
		    Var IngredientID As Int64 = Stream.ReadLine.Trim.ToInt64
		    For Each Range As Pair In FreshRanges
		      If IngredientID >= Range.Left.Int64Value And IngredientID <= Range.Right.Int64Value Then
		        AvailableFreshCount = AvailableFreshCount + 1
		        Exit
		      End If
		    Next
		  Wend
		  
		  Print("Available and fresh ingredient IDs: " + AvailableFreshCount.ToString)
		  
		  ///// PART 2 /////
		  
		  // Sort the ranges to assist merging
		  FreshRanges.Sort(AddressOf SortRanges)
		  
		  // Merge overlapping adjacent ranges
		  Var MergedRange As Boolean
		  Do
		    MergedRange = False
		    For Index As Integer = FreshRanges.LastIndex - 1 DownTo 0
		      If FreshRanges(Index + 1).Left.Int64Value - FreshRanges(Index).Right.Int64Value <= 1 Then
		        If FreshRanges(Index).Right.Int64Value >= FreshRanges(Index + 1).Right.Int64Value Then
		          FreshRanges(Index) = FreshRanges(Index).Left.Int64Value : FreshRanges(Index).Right.Int64Value
		        Else
		          FreshRanges(Index) = FreshRanges(Index).Left.Int64Value : FreshRanges(Index + 1).Right.Int64Value
		        End If
		        FreshRanges.RemoveAt(Index + 1)
		        MergedRange = True
		      End If
		    Next
		  Loop Until Not MergedRange
		  
		  // Sum the number of IDs in the ranges
		  Var FreshIngredients As Int64
		  For Each Range As Pair In FreshRanges
		    FreshIngredients = FreshIngredients + (Range.Right.Int64Value - Range.Left.Int64Value + 1)
		  Next
		  
		  Print("Fresh ingredient IDs: " + FreshIngredients.ToString)
		  
		  Return 0
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Function SortRanges(r1 As Pair, r2 As Pair) As Integer
		  If r1.Left.Int64Value <> r2.Left.Int64Value Then
		    Return r1.Left.Int64Value - r2.Left.Int64Value
		  Else
		    Return r1.Right.Int64Value - r2.Right.Int64Value
		  End If
		End Function
	#tag EndMethod


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
