#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // Process arguments
		  Var ArgFileName As String = args(1)
		  Var ArgConnections As Integer = args(2).ToInteger
		  If ArgFileName = "" Then
		    Print("Must specify file to read.")
		    Return 0
		  ElseIf ArgConnections < 1 Then
		    Print("Must specify number of connections to make.")
		    Return 0
		  End If
		  
		  // Open file for reading
		  Try
		    Read(ArgFileName)
		  Catch
		    Print("Error reading input file.")
		    Return 0
		  End Try
		  
		  ///// PART 1 /////
		  
		  // Populate BoxPairs() with all possible connections
		  // Sort by distance ascending
		  CreateSortedPairs
		  
		  // Compute the circuit sizes
		  Var BoxCounts() As Integer = CircuitSizesForConnectionCount(ArgConnections)
		  
		  // Find the product of the three largest circuit box counts
		  Var Product As Integer = 1
		  For Index As Integer = BoxCounts.Count - kLargestCircuitCount To BoxCounts.LastIndex
		    Product = Product * BoxCounts(Index)
		  Next
		  
		  Print("[PART 1] Product of " + kLargestCircuitCount.ToString + " largest circuit sizes: " + Product.ToString)
		  
		  ///// PART 2 /////
		  
		  // Determine connection count required for all boxes to be connected on one circuit
		  Var MinConnectionCount As Integer = Boxes.Count - 1
		  Var MaxConnectionCount As Integer = BoxPairs.Count
		  Do Until MinConnectionCount = MaxConnectionCount
		    Var ConnectionCount As Integer = Floor((MinConnectionCount + MaxConnectionCount) / 2.0)
		    Var Counts() As Integer = CircuitSizesForConnectionCount(ConnectionCount)
		    Var FullyConnected As Boolean = Counts.Count = 1 And Counts(0) = Boxes.Count
		    If FullyConnected Then
		      MaxConnectionCount = ConnectionCount
		    Else
		      MinConnectionCount = ConnectionCount + 1
		    End If
		  Loop
		  
		  // Return the product of the X coordinates of the last connection required
		  Var LastConnection As JunctionBoxPair = BoxPairs(MinConnectionCount - 1)
		  Product = LastConnection.Box1.X * LastConnection.Box2.X
		  Print("[PART 2] Product of X coordinates of last connection required to fully connect: " + Product.ToString)
		  
		  Return 0
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Function CircuitSizes(connections() As JunctionBoxPair) As Integer()
		  Var Result() As Integer
		  Do Until connections.Count = 0
		    
		    // Add boxes from one of the connections
		    Var CircuitBoxes() As JunctionBox
		    Var BoxPair As JunctionBoxPair = connections.Pop
		    CircuitBoxes.Add(BoxPair.Box1)
		    CircuitBoxes.Add(BoxPair.Box2)
		    
		    // Add boxes connected to those boxes
		    For CircuitIndex As Integer = 0 To CircuitBoxes.LastIndex
		      For ConnectionsIndex As Integer = connections.LastIndex DownTo 0
		        BoxPair = connections(ConnectionsIndex)
		        Var Box1Index As Integer = CircuitBoxes.IndexOf(BoxPair.Box1)
		        Var Box2Index As Integer = CircuitBoxes.IndexOf(BoxPair.Box2)
		        If Box1Index >= 0 Or Box2Index >= 0 Then // Is connected to existing circuit
		          If Box1Index < 0 Then CircuitBoxes.Add(BoxPair.Box1)
		          If Box2Index < 0 Then CircuitBoxes.Add(BoxPair.Box2)
		          connections.RemoveAt(ConnectionsIndex)
		        End If
		      Next
		    Next
		    
		    // Add number of boxes in the circuit to results
		    Result.Add(CircuitBoxes.Count)
		    
		  Loop
		  Result.Sort
		  Return Result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CircuitSizesForConnectionCount(connectionCount As Integer) As Integer()
		  // Make an array with the closest ConnectionCount junction box pairs
		  Var Connections() As JunctionBoxPair
		  For Index As Integer = connectionCount - 1 DownTo 0
		    Connections.Add(BoxPairs(Index))
		  Next
		  Return CircuitSizes(Connections)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateSortedPairs()
		  For Box1 As Integer = 0 To Boxes.LastIndex - 1
		    For Box2 As Integer = Box1 + 1 To Boxes.LastIndex
		      BoxPairs.Add(New JunctionBoxPair(Boxes(Box1), Boxes(Box2)))
		    Next
		  Next
		  BoxPairs.Sort(AddressOf JunctionBoxPair.CompareDistance)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Read(name As String)
		  Var Stream As TextInputStream = TextInputStream.Open(New FolderItem(name))
		  Do Until Stream.EndOfFile
		    Boxes.Add(JunctionBox.FromString(Stream.ReadLine.Trim))
		  Loop
		  Stream.Close
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Boxes() As JunctionBox
	#tag EndProperty

	#tag Property, Flags = &h0
		BoxPairs() As JunctionBoxPair
	#tag EndProperty


	#tag Constant, Name = kLargestCircuitCount, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
