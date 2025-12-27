#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // This is an NP-hard problem. The input has been designed to only include trivial cases.
		  // ShapeArea contains the areas of the bounds of the different shapes. We don't have to 
		  // consider the actual shapes because we're not really trying to fit them together.
		  // Regions is two-dimensional. The first dimension is the region index. The second dimension
		  // indexes the region width, the region height, and then the shape counts for each shape.
		  
		  // Read input file
		  Try
		    ReadFile(args(1))
		  Catch
		    Print("Error reading input file.")
		    Return 0
		  End Try
		  
		  // Find the number of regions with enough space for all the shape bounds
		  // (Neglecting the actual shapes) 
		  Var RegionsThatFit As Integer
		  For RegionIndex As Integer = 0 To Regions.LastIndex(1)
		    Var RegionArea As Integer = Regions(RegionIndex, 0) * Regions(RegionIndex, 1)
		    Var ContentsArea As Integer
		    For Index As Integer = 2 To Regions.LastIndex(2)
		      ContentsArea = ContentsArea + Regions(RegionIndex, Index) * ShapeArea(Index - 2)
		    Next
		    If ContentsArea <= RegionArea Then RegionsThatFit = RegionsThatFit + 1
		  Next
		  
		  Print("Regions that fit: " + RegionsThatFit.ToString)
		  Return 0
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub ReadFile(name As String)
		  // Read area of shape bounds and the region sizes and shape counts
		  Var Stream As TextInputStream = TextInputStream.Open(New FolderItem(name))
		  Do Until Stream.EndOfFile
		    Var Line As String = Stream.ReadLine.Trim
		    If Line = "" Then
		      Continue
		    ElseIf Line.EndsWith(":") Then // Read area of shape bounds
		      '0:
		      '###
		      '..#
		      '###
		      Var ShapeIndex As Integer = Line.NthField(":", 1).ToInteger
		      If ShapeArea.LastIndex < ShapeIndex Then ShapeArea.ResizeTo(ShapeIndex)
		      Do Until Stream.EndOfFile
		        Var LineLength As Integer = Stream.ReadLine.Trim.Length
		        If LineLength > 0 Then ShapeArea(ShapeIndex) = ShapeArea(ShapeIndex) + LineLength Else Exit
		      Loop
		    ElseIf Line.Contains(": ") Then // Region
		      '48x46: 65 55 51 61 53 53
		      Var Parts() As String = Line.Replace("x", " ").Replace(":", "").ToArray(" ")
		      Regions.ResizeTo(Regions.LastIndex(1) + 1, Max(Regions.LastIndex(2), Parts.LastIndex))
		      For Index As Integer = 0 To Parts.LastIndex
		        Regions(Regions.LastIndex(1), Index) = Parts(Index).ToInteger
		      Next
		    Else
		      Raise New RuntimeException("Malformed input.")
		    End If
		  Loop
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Regions(-1,-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ShapeArea() As Integer
	#tag EndProperty


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
