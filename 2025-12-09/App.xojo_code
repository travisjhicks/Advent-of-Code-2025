#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  #Pragma BackgroundTasks False
		  #Pragma BoundsChecking False
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  // Read input into RedTiles array
		  Try
		    Read(args(1))
		  Catch
		    Print("Error reading input file.")
		    Return 0
		  End Try
		  
		  ///// PART 1 /////
		  
		  // Populate RedRects and RedRectAreas with every rect bounding two red tiles
		  For Index1 As Integer = 0 To RedTiles.LastIndex - 1
		    For Index2 As Integer = Index1 + 1 To RedTiles.LastIndex
		      RedRects.Add(RedTiles(Index1) : RedTiles(Index2))
		      RedRectAreas.Add(RedTiles(Index1).UnionArea(RedTiles(Index2)))
		    Next
		  Next
		  RedRectAreas.SortWith(RedRects)
		  
		  Print("[PART 1] Area of largest rectangle: " + RedRectAreas(RedRectAreas.LastIndex).ToString)
		  
		  ///// PART 2 /////
		  
		  // I'm sure there are ways of optimizing this further.
		  // This takes about 13 minutes to find the actual solution.
		  
		  For Index As Integer = RedRects.LastIndex DownTo 0
		    Print("Checking index " + Index.ToString + "...")
		    Var Tile1 As Tile = RedRects(Index).Left
		    Var Tile2 As Tile = RedRects(Index).Right
		    If RectRedAndGreen(Min(Tile1.X, Tile2.X), Min(Tile1.Y, Tile2.Y), Max(Tile1.X, Tile2.X), Max(Tile1.Y, Tile2.Y)) Then
		      Print("[PART 2] Area of largest rectangle with only red and green tiles: " + RedRectAreas(Index).ToString)
		      Exit
		    End If
		  Next
		  
		  Return 0
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Read(name As String)
		  #Pragma BackgroundTasks False
		  Var Stream As TextInputStream = TextInputStream.Open(New FolderItem(name))
		  Do Until Stream.EndOfFile
		    RedTiles.Add(Tile.FromString(Stream.ReadLine.Trim))
		  Loop
		  Stream.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RectRedAndGreen(minX As Integer, minY As Integer, maxX As Integer, maxY As Integer) As Boolean
		  #Pragma BackgroundTasks False
		  #Pragma BoundsChecking False
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  // Look around each vertex for a tile within our boundary that is not red or green
		  For Each t As Tile In RedTiles
		    For x As Integer = t.X - 1 To t.X + 1
		      For y As Integer = t.Y - 1 To t.Y + 1
		        If t.X = x And t.Y = y Then Continue
		        If x < minX Or x > maxX Or y < minY Or y > maxY Then Continue
		        If Not TileRedOrGreen(x, y) Then Return False
		      Next
		    Next
		  Next
		  
		  // Verify around perimeter
		  For x As Integer = minX To maxX
		    If Not TileRedOrGreen(x, minY) Or Not TileRedOrGreen(x, maxY) Then Return False
		  Next
		  For y As Integer = minY To maxY
		    If Not TileRedOrGreen(minX, y) Or Not TileRedOrGreen(maxX, y) Then Return False
		  Next
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TileRedOrGreen(x As Integer, y As Integer) As Boolean
		  #Pragma BackgroundTasks False
		  #Pragma BoundsChecking False
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Var Tile1, Tile2 As Tile
		  Var WindingNumber As Integer
		  
		  Tile1 = RedTiles(0)
		  If Tile1.X = x And Tile1.Y = y Then Return True
		  For Tile2Index As Integer = 1 To RedTiles.Count
		    Tile2 = RedTiles(Tile2Index Mod RedTiles.Count)
		    
		    // Red
		    If Tile2.X = x And Tile2.Y = y Then Return True
		    
		    // Boundary
		    If Tile1.X = Tile2.X And Tile1.X = x Then
		      If Min(Tile1.Y, Tile2.Y) <= y And y <= Max(Tile1.Y, Tile2.Y) Then Return True
		    ElseIf Tile1.Y = Tile2.Y And Tile1.Y = y Then
		      If Min(Tile1.X, Tile2.X) <= x And x <= Max(Tile1.X, Tile2.X) Then Return True
		    End If
		    
		    // Inside loop
		    // Based on improved winding number algorithm by Dan Sunday adapted for these discrete tiles
		    If Tile1.X = Tile2.X Then // Vertical line
		      If x < Tile1.X Then // Line is to our right
		        If Min(Tile1.Y, Tile2.Y) <= y And y < Max(Tile1.Y, Tile2.Y) Then // Ray will intersect
		          WindingNumber = WindingNumber + Sign(Tile2.Y - Tile1.Y)
		        End If
		      End If
		    End If
		    
		    Tile1 = Tile2
		  Next
		  Return WindingNumber <> 0
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		RedRectAreas() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		RedRects() As Pair
	#tag EndProperty

	#tag Property, Flags = &h0
		RedTiles() As Tile
	#tag EndProperty


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
