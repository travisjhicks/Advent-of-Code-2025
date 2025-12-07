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
		  
		  Var PrevPaths(), NextPaths() As Integer
		  Var Splits As Integer
		  
		  // Initialize with one path at the start
		  For Each Char As String In Stream.ReadLine.ReplaceAll("S", "|").Characters
		    PrevPaths.Add(If(Char = "|", 1, 0))
		  Next
		  
		  Do Until Stream.EndOfFile
		    
		    // Read in line to determine where splitters are
		    Var Splitters() As String = Stream.ReadLine.ToArray("")
		    
		    // Reset next paths to zero
		    NextPaths.RemoveAll
		    NextPaths.ResizeTo(PrevPaths.LastIndex)
		    
		    // Compute number of paths for each beam
		    For Index As Integer = 0 To NextPaths.LastIndex
		      If PrevPaths(Index) = 0 Then Continue
		      If Splitters(Index) = "^" Then
		        If Index > 0 Then NextPaths(Index - 1) = NextPaths(Index - 1) + PrevPaths(Index)
		        If Index < NextPaths.LastIndex Then NextPaths(Index + 1) = NextPaths(Index + 1) + PrevPaths(Index)
		        Splits = Splits + 1
		      Else
		        NextPaths(Index) = NextPaths(Index) + PrevPaths(Index)
		      End If
		    Next
		    
		    // Copy next state to previous state
		    For Index As Integer = 0 To NextPaths.LastIndex
		      PrevPaths(Index) = NextPaths(Index)
		    Next
		    
		  Loop
		  
		  // Sum the paths for the last row to determine total number of timelines
		  Var Timelines As Integer
		  For Each Paths As Integer In PrevPaths
		    Timelines = Timelines + Paths
		  Next
		  
		  Print("Part 1 splits: " + Splits.ToString)
		  Print("Part 2 timelines: " + Timelines.ToString)
		  Return 0
		End Function
	#tag EndEvent


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
