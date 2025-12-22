#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  Var LightPresses, JoltagePresses  As Integer
		  
		  // Open file for reading
		  Var Stream As TextInputStream
		  Try
		    Stream = TextInputStream.Open(New FolderItem(args(1)))
		  Catch
		    Stream.Close
		    Print("Error reading input file.")
		    Return 0
		  End Try
		  
		  // Process the machine on each line
		  Do Until Stream.EndOfFile
		    Var Line As String = Stream.ReadLine.Trim
		    LoadMachine(Line)
		    
		    Try
		      Var Presses As Integer = SolveMinimumPressesForLights
		      Print("Presses to set light: " + Presses.ToString)
		      LightPresses = LightPresses + Presses
		    Catch
		      Stream.Close
		      Print("Could not solve lights for line: " + Line)
		      Return 0
		    End Try
		    
		    Try
		      Var Presses As Integer = SolveMinimumPressesForJoltage
		      Print("Presses to set joltage: " + Presses.ToString)
		      JoltagePresses = JoltagePresses + Presses
		    Catch
		      Stream.Close
		      Print("Could not solve joltage for line: " + Line)
		      Return 0
		    End Try
		    
		  Loop
		  Stream.Close
		  Print("[Part 1] Minimum button presses to configure machine lights: " + LightPresses.ToString)
		  Print("[Part 2] Minimum button presses to configure machine joltage: " + JoltagePresses.ToString)
		  Return 0
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Function ButtonsSolveJoltage(pushCounts() As Integer) As Boolean
		  // Check whether pressing the buttons at the provided
		  // indices will set the desired joltage.
		  
		  #Pragma BackgroundTasks   False
		  #Pragma BoundsChecking    False
		  #Pragma NilObjectChecking False
		  
		  Var State() As Integer
		  State.ResizeTo(M.LastIndex(2))
		  
		  For x As Integer = 0 To pushCounts.LastIndex
		    If pushCounts(x) <= 0 Then Continue
		    For y As Integer = 0 To m.LastIndex(2)
		      State(y) = State(y) + M(x, y) * pushCounts(x)
		    Next
		  Next
		  
		  For Index As Integer = 0 To Joltage.LastIndex
		    If State(Index) <> Joltage(Index) Then Return False
		  Next
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ButtonsSolveLights(buttonIndices() As Integer) As Boolean
		  // Check whether pressing the buttons at the provided
		  // indices will set the desired light pattern.
		  
		  #Pragma BackgroundTasks   False
		  #Pragma BoundsChecking    False
		  #Pragma NilObjectChecking False
		  
		  Var State() As Boolean
		  State.ResizeTo(M.LastIndex(2))
		  
		  For Each x As Integer In buttonIndices
		    For y As Integer = 0 To M.LastIndex(2)
		      If M(x, y) > 0 Then State(y) = Not State(y)
		    Next
		  Next
		  
		  For Index As Integer = 0 To Lights.LastIndex
		    If State(Index) <> Lights(Index) Then Return False
		  Next
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FindJoltageSolutions(constraints() As Integer, joltageIndex As Integer)
		  #Pragma BackgroundTasks   False
		  #Pragma BoundsChecking    False
		  #Pragma NilObjectChecking False
		  
		  // If there is no more to process then our constraints are a solution
		  If joltageIndex > M.LastIndex(2) Then
		    JoltageSolutions.ResizeTo(JoltageSolutions.LastIndex(1) + 1, M.LastIndex(1))
		    For Index As Integer = 0 To constraints.LastIndex
		      JoltageSolutions(JoltageSolutions.LastIndex(1), Index) = Max(constraints(Index), 0)
		    Next
		    Return
		  End If
		  
		  // Find the buttons that affect this joltage index that are not
		  // already bound by a constraint set by the caller
		  Var FreeIndices() As Integer
		  Var Sum As Integer = Joltage(joltageIndex)
		  For x As Integer = 0 To M.LastIndex(1)
		    If M(x, joltageIndex) = 0 Then Continue
		    If constraints(x) >= 0 Then
		      Sum = Sum - constraints(x)
		      If Sum < 0 Then Return
		      Continue For x
		    End If
		    FreeIndices.Add(x)
		  Next
		  
		  // If there are no indicies we can adjust then we have
		  // either failed or need to pass to the next joltage index
		  If FreeIndices.Count = 0 Then
		    If Sum = 0 Then FindJoltageSolutions(constraints, joltageIndex + 1)
		    Return
		  End If
		  
		  // Iterate through all combinations of free indicies to make remaining sum
		  Var Pushes() As Integer
		  Pushes.ResizeTo(FreeIndices.LastIndex)
		  Pushes(0) = Sum
		  Do
		    
		    // Add this combination as a constraint and pass to next joltage index
		    Var NextConstraints() As Integer
		    NextConstraints.ResizeTo(constraints.LastIndex)
		    For Index As Integer = 0 To constraints.LastIndex
		      NextConstraints(Index) = constraints(Index)
		    Next
		    For Index As Integer = 0 To Pushes.LastIndex
		      NextConstraints(FreeIndices(Index)) = Pushes(Index)
		    Next
		    FindJoltageSolutions(NextConstraints, joltageIndex + 1)
		    
		    // Find the next combination
		    For Index As Integer = Pushes.LastIndex - 1 DownTo 0
		      If Pushes(Index) = 0 Then Continue
		      Pushes(Index) = Pushes(Index) - 1
		      Pushes(Index + 1) = 1 + Pushes(Pushes.LastIndex)
		      For ZeroIndex As Integer = Index + 2 To Pushes.LastIndex
		        Pushes(ZeroIndex) = 0
		      Next
		      Continue Do
		    Next
		    Exit Do
		    
		  Loop
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadMachine(line As String)
		  #Pragma BackgroundTasks   False
		  #Pragma BoundsChecking    False
		  #Pragma NilObjectChecking False
		  
		  // [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
		  Var Parts() As String = line.ToArray(" ")
		  
		  // Lights
		  Lights.RemoveAll
		  For Each Char As String In Parts(0).Trim("[", "]").Characters
		    Lights.Add(Char = "#")
		  Next
		  Parts.RemoveAt(0)
		  
		  // Joltage
		  Joltage.RemoveAll
		  For Each Value As String In Parts.Pop.Trim("{", "}").ToArray(",")
		    Joltage.Add(Value.Trim.ToInteger)
		  Next
		  
		  // Buttons
		  // Use matrix M(x, y) where x is the button index and y is the light/joltage index
		  M.ResizeTo(-1, -1)
		  M.ResizeTo(Parts.LastIndex, Lights.LastIndex)
		  For x As Integer = 0 To Parts.LastIndex
		    Var ButtonMask() As Boolean
		    ButtonMask.ResizeTo(Lights.LastIndex)
		    For Each ButtonValue As String In Parts(x).Trim("(", ")").ToArray(",")
		      ButtonMask(ButtonValue.ToInteger) = True
		    Next
		    For y As Integer = 0 To Lights.LastIndex
		      M(x, y) = If(ButtonMask(y), 1, 0)
		    Next
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SolveMinimumPressesForJoltage() As Integer
		  // If the joltage is all zero then there isn't anything to do
		  Var AllZero As Boolean = True
		  For Each Value As Integer In Joltage
		    If Value > 0 Then
		      AllZero = False
		      Exit
		    End If
		  Next
		  If AllZero Then Return 0
		  
		  // Use recursive function to traverse all possible solutions given constraints
		  JoltageSolutions.ResizeTo(-1, -1)
		  Var Constraints() As Integer
		  Constraints.ResizeTo(M.LastIndex(1))
		  For Index As Integer = 0 To Constraints.LastIndex
		    Constraints(Index) = -1
		  Next
		  FindJoltageSolutions(Constraints, 0)
		  
		  // Find the minimum number of button presses required for all solutions
		  Var Minimum As Integer
		  For SolutionIndex As Integer = 0 To JoltageSolutions.LastIndex(1)
		    Var Presses As Integer
		    For PressIndex As Integer = 0 To JoltageSolutions.LastIndex(2)
		      Presses = Presses + JoltageSolutions(SolutionIndex, PressIndex)
		    Next
		    If Presses = 0 Then Return 0
		    Minimum = If(SolutionIndex = 0, Presses, Min(Minimum, Presses))
		  Next
		  Return Minimum
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SolveMinimumPressesForLights() As Integer
		  // If all the lights are off then there isn't anything to do
		  Var AllOff As Boolean = True
		  For Each Value As Boolean In Lights
		    If Value Then
		      AllOff = False
		      Exit
		    End If
		  Next
		  If AllOff Then Return 0
		  
		  // Try progressively larger combinations without duplication
		  For k As Integer = 1 To M.Count(1)
		    
		    // Choose k
		    Var ButtonIndices() As Integer
		    For InitialIndex As Integer = 0 To k - 1
		      ButtonIndices.Add(InitialIndex)
		    Next
		    Do
		      
		      // Test this combination
		      If ButtonsSolveLights(ButtonIndices) Then Return k
		      
		      // Go to the next combination without duplication
		      For Index As Integer = ButtonIndices.LastIndex DownTo 0
		        If ButtonIndices(Index) < M.LastIndex(1) And ButtonIndices.IndexOf(ButtonIndices(Index) + 1) < 0 Then
		          ButtonIndices(Index) = ButtonIndices(Index) + 1
		          For IndexToReset As Integer = Index + 1 To ButtonIndices.LastIndex
		            ButtonIndices(IndexToReset) = ButtonIndices(Index) + IndexToReset - Index
		          Next
		          Continue Do
		        ElseIf Index = 0 And k = M.Count(1) Then
		          Exit For k
		        End If
		      Next
		      Continue For k
		      
		    Loop
		  Next
		  Raise New RuntimeException("Light solution not found.")
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Joltage() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		JoltageSolutions(-1,-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Lights() As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		M(-1,-1) As Integer
	#tag EndProperty


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
