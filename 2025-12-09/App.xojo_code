#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // Read input into grid
		  Try
		    Read(args(1))
		  Catch
		    Print("Error reading input file.")
		    Return 0
		  End Try
		  
		  ///// PART 1 /////
		  
		  Var MaxArea As Integer
		  For Index1 As Integer = 0 To RedTiles.LastIndex - 1
		    For Index2 As Integer = Index1 + 1 To RedTiles.LastIndex
		      Var Area As Integer = RedTiles(Index1).UnionArea(RedTiles(Index2))
		      If Area > MaxArea Then
		        MaxArea = Area
		      End If
		    Next
		  Next
		  
		  Print("[PART 1] Area of largest rectangle: " + MaxArea.ToString)
		  
		  ///// PART 2 /////
		  
		  Return 0
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Read(name As String)
		  Var Stream As TextInputStream = TextInputStream.Open(New FolderItem(name))
		  Do Until Stream.EndOfFile
		    RedTiles.Add(Tile.FromString(Stream.ReadLine.Trim))
		  Loop
		  Stream.Close
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		RedTiles() As Tile
	#tag EndProperty


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
