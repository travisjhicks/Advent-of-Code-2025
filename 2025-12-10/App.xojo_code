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
		      LightPresses = LightPresses + SolveMinimumPressesForLights(TargetLights)
		      JoltagePresses = JoltagePresses + SolveMinimumPressesForJoltage(TargetJoltage)
		      Print(LightPresses.ToString + " " + JoltagePresses.ToString)
		    Catch
		      Stream.Close
		      Print("Could not solve for line: " + Line)
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
		Sub LoadMachine(line As String)
		  // [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
		  Var Parts() As String = line.ToArray(" ")
		  
		  // Lights
		  // [.##.] -> Array(False, True, True, False)
		  TargetLights.RemoveAll
		  For Each Char As String In Parts(0).Trim("[", "]").Characters
		    TargetLights.Add(Char = "#")
		  Next
		  Parts.RemoveAt(0)
		  
		  // Joltage
		  // {3,5,4,7} -> Array(3, 5, 4, 7)
		  TargetJoltage.RemoveAll
		  For Each Value As String In Parts.Pop.Trim("{", "}").ToArray(",")
		    TargetJoltage.Add(Value.Trim.ToInteger)
		  Next
		  
		  // Wiring
		  // First dimension is button index, second dimension is light/joltage index
		  Wiring.ResizeTo(-1, -1)
		  Wiring.ResizeTo(Parts.LastIndex, TargetLights.LastIndex)
		  For x As Integer = 0 To Parts.LastIndex
		    For Each WiringIndex As String In Parts(x).Trim("(", ")").ToArray(",")
		      Wiring(x, WiringIndex.ToInteger) = True
		    Next
		  Next
		  
		  // Reset cache
		  LightSolutionCache = New Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PressesSolveJoltage(presses() As Integer, joltage() As Integer) As Boolean
		  // Check whether pressing the buttons the provided number of times will set the desired joltage
		  Var Result() As Integer = PressesToJoltage(presses)
		  For Index As Integer = 0 To joltage.LastIndex
		    If joltage(Index) <> Result(Index) Then Return False
		  Next
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PressesSolveLights(presses() As Integer, lights() As Boolean) As Boolean
		  // Check whether pressing the buttons the provided number of times will set the desired lights
		  Var Result() As Boolean = PressesToLights(presses)
		  For Index As Integer = 0 To lights.LastIndex
		    If lights(Index) <> Result(Index) Then Return False
		  Next
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PressesToJoltage(presses() As Integer) As Integer()
		  // Calculate the joltages after pressing buttons the provided number of times
		  Var Result() As Integer
		  Result.ResizeTo(wiring.LastIndex(2))
		  For ButtonIndex As Integer = 0 To presses.LastIndex
		    If presses(ButtonIndex) = 0 Then Continue
		    For JoltageIndex As Integer = 0 To wiring.LastIndex(2)
		      If Not wiring(ButtonIndex, JoltageIndex) Then Continue
		      Result(JoltageIndex) = Result(JoltageIndex) + presses(ButtonIndex)
		    Next
		  Next
		  Return Result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PressesToLights(presses() As Integer) As Boolean()
		  // Calculate the lights after pressing buttons the provided number of times
		  Var Result() As Boolean
		  For Each JoltageValue As Integer In PressesToJoltage(presses)
		    Result.Add(JoltageValue Mod 2 = 1)
		  Next
		  Return Result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SolutionsForLights(lights() As Boolean) As Integer(,)
		  // Try to return cached solution
		  Var Key As String
		  For Each Value As Boolean In lights
		    Key = Key + If(Value, "#", ".")
		  Next
		  If LightSolutionCache.HasKey(Key) Then Return LightSolutionCache.Value(Key)
		  
		  // Try all combinations of pressing each button zero or one times
		  Var Solutions(-1, -1) As Integer
		  Solutions.ResizeTo(-1, Wiring.LastIndex(1))
		  Var Presses() As Integer
		  Presses.ResizeTo(Wiring.LastIndex(1))
		  Do
		    
		    // Test this combination
		    If PressesSolveLights(Presses, lights) Then
		      Solutions.ResizeTo(Solutions.Count(1), Solutions.LastIndex(2))
		      For Index As Integer = 0 To Solutions.LastIndex(2)
		        Solutions(Solutions.LastIndex(1), Index) = Presses(Index)
		      Next
		    End If
		    
		    // Go to the next combination
		    For Index As integer = Presses.LastIndex DownTo 0
		      If Presses(Index) = 0 Then
		        Presses(Index) = 1
		        For IndexToReset As Integer = Index + 1 To Presses.LastIndex
		          Presses(IndexToReset) = 0
		        Next
		        Continue Do
		      ElseIf Index = 0 Then
		        Exit Do
		      End If
		    Next
		    
		  Loop
		  
		  LightSolutionCache.Value(Key) = Solutions
		  Return Solutions
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SolveMinimumPressesForJoltage(joltage() As Integer) As Integer
		  // Algorithm concept by tenthmascot
		  // https://www.reddit.com/r/adventofcode/comments/1pk87hl/2025_day_10_part_2_bifurcate_your_way_to_victory/
		  // 
		  // My initial solution was to loop through each light/joltage index, determine which buttons affect that 
		  // index, and recursively explores all combinations. This was impractically slow for the actual problem 
		  // input. Data was stored conceptually as a matrix (implemented as a 2D array) representing the system of 
		  // linear equations. I intended to proceed by implementing row reduction to solve the system of linear 
		  // equations or just to reduce the number of free variables to search.
		  // 
		  // I stumbled across tenthmascot's solution and found it so elegant and consistent with part 1 that I had 
		  // to pivot to it.
		  // 
		  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
		  
		  #Pragma BreakOnExceptions False
		  
		  Var SolutionFound As Boolean
		  Var MinimumPresses As Integer
		  
		  // Solve for the odd parity of the joltage/lights
		  Var ParityJoltage() As Integer
		  Var ParityLights() As Boolean
		  For Each JoltageValue As Integer In joltage
		    ParityJoltage.Add(JoltageValue Mod 2)
		    ParityLights.Add(ParityJoltage(ParityJoltage.LastIndex) = 1)
		  Next
		  
		  // Find all light solutions and recurse with remaining joltage
		  Var LightSolutions(-1, -1) As Integer = SolutionsForLights(ParityLights)
		  If LightSolutions.Count(1) = 0 Then Raise New RuntimeException("Joltage solution not found.")
		  For SolutionIndex As Integer = 0 To LightSolutions.LastIndex(1)
		    
		    // Find joltage change for this light solution
		    Var Presses() As Integer
		    For ButtonIndex As Integer = 0 To LightSolutions.LastIndex(2)
		      Presses.Add(LightSolutions(SolutionIndex, ButtonIndex))
		    Next
		    Var JoltageChange() As Integer = PressesToJoltage(Presses)
		    Var PressCount As Integer = Sum(Presses)
		    
		    // Split the remaining joltage, which must be even, and use recursion
		    Var RemainingJoltage() As Integer
		    RemainingJoltage.ResizeTo(joltage.LastIndex)
		    For Index As Integer = 0 To joltage.LastIndex
		      RemainingJoltage(Index) = (joltage(Index) - JoltageChange(Index)) / 2
		      If RemainingJoltage(Index) < 0 Then Continue For SolutionIndex
		    Next
		    If Sum(RemainingJoltage) > 0 Then
		      Try
		        PressCount = PressCount + 2 * SolveMinimumPressesForJoltage(RemainingJoltage)
		      Catch
		        Continue For SolutionIndex
		      End Try
		    End If
		    MinimumPresses = If(SolutionFound, Min(MinimumPresses, PressCount), PressCount)
		    SolutionFound = True
		    
		  Next
		  
		  If Not SolutionFound Then Raise New RuntimeException("Joltage solution not found.")
		  Return MinimumPresses
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SolveMinimumPressesForLights(lights() As Boolean) As Integer
		  // Find the minimum number of button presses to set the light pattern
		  
		  Var Solutions(-1, -1) As Integer = SolutionsForLights(lights)
		  If Solutions.Count(1) = 0 Then Raise New RuntimeException("Light solution not found.")
		  
		  Var MinimumPresses As Integer
		  For SolutionIndex As Integer = 0 To Solutions.LastIndex(1)
		    Var Presses As Integer
		    For ButtonIndex As Integer = 0 To Solutions.LastIndex(2)
		      Presses = Presses + Solutions(SolutionIndex, ButtonIndex)
		    Next
		    If SolutionIndex = 0 Or Presses < MinimumPresses Then MinimumPresses = Presses
		    If MinimumPresses = 0 Then Exit
		  Next
		  Return MinimumPresses
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Sum(values() As Integer) As Integer
		  Var Result As Integer
		  For Each Value As Integer In values
		    Result = Result + Value
		  Next
		  Return Result
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		LightSolutionCache As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		TargetJoltage() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		TargetLights() As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Wiring(-1,-1) As Boolean
	#tag EndProperty


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
