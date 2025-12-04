#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  Var Grid(-1, -1) As Boolean
		  Try
		    Grid = ReadGrid(args(1))
		  Catch
		    Print("Error reading input file.")
		    Return 0
		  End Try
		  
		  // Part 1
		  // Counting accessible rolls
		  Print("Accessible rolls: " + CountAccessibleRolls(Grid, kMaxAdjacent).ToString)
		  
		  // Part 2
		  // Counting accessible rolls with repeated removal
		  Var Count, Accessible As Integer
		  Do
		    Accessible = CountAccessibleRolls(Grid, kMaxAdjacent, True)
		    Count = Count + Accessible
		  Loop Until Accessible = 0
		  Print("Accessible rolls with removal: " + Count.ToString)
		  
		  Return 0
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Shared Function AdjacentRolls(grid(, ) As Boolean, x As Integer, y As Integer) As Integer
		  #Pragma BackgroundTasks False
		  Var Adjacent As Integer
		  For yAdj As Integer = y - 1 To y + 1
		    For xAdj As Integer = x - 1 To x + 1
		      If xAdj = x And yAdj = y Then Continue
		      If xAdj < 0 Or xAdj > grid.LastIndex(1) Then Continue
		      If yAdj < 0 Or yAdj > grid.LastIndex(2) Then Continue For yAdj
		      If grid(xAdj, yAdj) Then Adjacent = Adjacent + 1
		    Next
		  Next
		  Return Adjacent
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function CountAccessibleRolls(grid(, ) As Boolean, maxAdjacent As Integer, Optional removeAccessible As Boolean) As Integer
		  #Pragma BackgroundTasks False
		  
		  Var Count As Integer
		  Var Accessible(-1, -1) As Boolean
		  Accessible.ResizeTo(grid.LastIndex(1), grid.LastIndex(2))
		  
		  // Count accessible rolls and store where they are
		  For y As Integer = 0 To grid.LastIndex(2)
		    For x As Integer = 0 To grid.LastIndex(1)
		      If grid(x, y) And AdjacentRolls(grid, x, y) <= maxAdjacent Then
		        Accessible(x, y) = True
		        Count = Count + 1
		      End If
		    Next
		  Next
		  
		  // Remove the accessible rolls
		  If removeAccessible Then
		    For y As Integer = 0 To grid.LastIndex(2)
		      For x As Integer = 0 To grid.LastIndex(1)
		        If Accessible(x, y) Then grid(x, y) = False
		      Next
		    Next
		  End If
		  
		  Return Count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ReadGrid(name As String) As Boolean(,)
		  #Pragma BackgroundTasks False
		  
		  // Read input file
		  // Don't assume all lines are the same length just in case
		  Var Stream As TextInputStream = TextInputStream.Open(New FolderItem(name))
		  Var Lines() As String
		  Var MaxLineLength As Integer
		  While Not Stream.EndOfFile
		    Lines.Add(Stream.ReadLine.Trim)
		    MaxLineLength = Max(MaxLineLength, Lines(Lines.LastIndex).Length)
		  Wend
		  
		  // Populate grid
		  Var Grid(-1, -1) As Boolean
		  Grid.ResizeTo(MaxLineLength - 1, Lines.LastIndex)
		  For y As Integer = 0 To Grid.LastIndex(2)
		    For x As Integer = 0 To Grid.LastIndex(1)
		      Grid(x, y) = (Lines(y).Middle(x, 1) = kRoll)
		    Next
		  Next
		  
		  Return Grid
		End Function
	#tag EndMethod


	#tag Constant, Name = kMaxAdjacent, Type = Double, Dynamic = False, Default = \"3", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kRoll, Type = String, Dynamic = False, Default = \"@", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
