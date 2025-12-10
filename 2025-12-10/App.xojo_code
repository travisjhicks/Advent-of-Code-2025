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
		  
		  Var LightPresses, JoltagePresses  As Integer
		  Do Until Stream.EndOfFile
		    Var Line As String = Stream.ReadLine.Trim
		    Var m As New Machine(Line)
		    
		    ///// PART 1 ///// 
		    
		    // Try progressively larger combinations without duplication
		    If m.LightsAllOff Then Continue
		    For k As Integer = 1 To m.Buttons.Count
		      
		      // Choose k
		      Var ButtonIndices() As Integer
		      For InitialIndex As Integer = 0 To k - 1
		        ButtonIndices.Add(InitialIndex)
		      Next
		      Do
		        
		        // Test this combination
		        If m.TestLightButtons(ButtonIndices) Then
		          LightPresses = LightPresses + k
		          Exit For k
		        End If
		        
		        // Go to the next combination without duplication
		        For Index As Integer = ButtonIndices.LastIndex DownTo 0
		          If ButtonIndices(Index) < m.Buttons.LastIndex And ButtonIndices.IndexOf(ButtonIndices(Index) + 1) < 0 Then
		            ButtonIndices(Index) = ButtonIndices(Index) + 1
		            For LessSignificantDigitIndex As Integer = Index + 1 To ButtonIndices.LastIndex
		              ButtonIndices(LessSignificantDigitIndex) = ButtonIndices(Index) + LessSignificantDigitIndex - Index
		            Next
		            Continue Do
		          ElseIf Index = 0 Then
		            If k = m.Buttons.Count Then
		              Print("Failed to find combination for lights: " + Line)
		              Return 0
		            Else
		              Continue For k
		            End If
		          End If
		        Next
		        
		      Loop
		    Next
		    
		    ///// PART 2 /////
		    
		    If m.JoltageAllZero Then Continue
		    
		    // Find min/max pushes for each button
		    Var ButtonMin(), ButtonMax() As Integer
		    m.MinMaxForJoltage(ButtonMin, ButtonMax)
		    Var MinPushes As Integer
		    For Each Value As Integer In m.Joltage
		      MinPushes = Max(MinPushes, Value)
		    Next
		    Var MaxPushes As Integer = SumIntegers(ButtonMax)
		    
		    // Start out with minimum pushes
		    Var PushCounts() As Integer
		    For Index As Integer = 0 To ButtonMin.LastIndex
		      PushCounts.Add(ButtonMin(Index))
		    Next
		    
		    Do
		      
		      // Test this combination
		      If m.TestJoltageButtonPushCounts(PushCounts) Then
		        
		        Print("Found combination for " + Line)
		        For Each c As Integer In PushCounts
		          Print(c.ToString)
		        Next
		        
		        
		        JoltagePresses = JoltagePresses + SumIntegers(PushCounts)
		        Exit
		      End If
		      
		      // Go to the next combination
		      'Do
		      For Index As Integer = PushCounts.LastIndex DownTo 0
		        If PushCounts(Index) < ButtonMax(Index) Then
		          PushCounts(Index) = PushCounts(Index) + 1
		          For ResetIndex As Integer = Index + 1 To PushCounts.LastIndex
		            PushCounts(ResetIndex) = ButtonMin(ResetIndex)
		          Next
		          Exit For Index
		        ElseIf Index = 0 Then
		          Print("Failed to find combination for joltage: " + Line)
		          Return 0
		        End If
		      Next
		      'Loop Until SumIntegers(PushCounts) >= MinPushes
		      
		    Loop
		    
		  Loop // Loop reading lines
		  
		  Print("[Part 1] Minimum button presses to configure machine lights: " + LightPresses.ToString)
		  Print("[Part 2] Minimum button presses to configure machine joltage: " + JoltagePresses.ToString)
		  Return 0
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Function SumIntegers(values() As Integer) As Integer
		  Var Sum As Integer
		  For Index As Integer = 0 to values.LastIndex
		    Sum = Sum + values(Index)
		  Next
		  Return Sum
		End Function
	#tag EndMethod


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
