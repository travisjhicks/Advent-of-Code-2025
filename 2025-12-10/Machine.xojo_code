#tag Class
Protected Class Machine
	#tag Method, Flags = &h0
		Sub Constructor(line As String)
		  Var Parts() As String = line.ToArray(" ")
		  
		  // Add light pattern
		  Var LightPattern As String = Parts(0).Trim("[", "]")
		  For Each State As String In LightPattern.Characters
		    Light.Add(State = "#")
		  Next
		  
		  // Add buttons
		  For Index As Integer = 1 To Parts.LastIndex - 1
		    Buttons.Add(New Button(Parts(Index)))
		  Next
		  
		  // Add joltage
		  Var JoltageValues() As String = Parts(Parts.LastIndex).Trim("{", "}").ToArray(",")
		  For Each Value As String In JoltageValues
		    Joltage.Add(Value.Trim.ToInteger)
		  Next
		  
		  If Light.Count <> Joltage.Count Then Raise New InvalidArgumentException
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MinMaxForJoltage(ByRef ButtonMin() As Integer, ByRef ButtonMax() As Integer)
		  ButtonMin.ResizeTo(Buttons.LastIndex)
		  ButtonMax.ResizeTo(Buttons.LastIndex)
		  
		  // Make a matrix, one row per button, one column per joltage value, with the amount the button increments the joltage (1)
		  Var M(-1, -1) As Integer
		  M.ResizeTo(Joltage.LastIndex, Buttons.LastIndex)
		  For y As Integer = 0 To Buttons.LastIndex
		    For x As Integer = 0 To Joltage.LastIndex
		      M(x, y) = If(Buttons(y).Light.IndexOf(x) >= 0, 1, 0)
		    Next
		  Next
		  
		  For y As Integer = 0 To Buttons.LastIndex
		    Var s As String
		    For x As Integer = 0 To Joltage.LastIndex
		      s = s + M(x, y).ToString + " "
		    Next
		    Print(s)
		  Next
		  
		  // Establish ranges of possible button pushes
		  For JoltageIndex As Integer = 0 To Joltage.LastIndex
		    
		    // Find the number of buttons that can affect this joltage
		    Var ButtonsAffectingJoltage() As Integer
		    For y As Integer = 0 To M.LastIndex(2)
		      If M(JoltageIndex, y) = 1 Then ButtonsAffectingJoltage.Add(y)
		    Next
		    print("buttons affecting joltage " + joltageindex.tostring + " " + ButtonsAffectingJoltage.Count.tostring)
		    
		    // Update min/max
		    If ButtonsAffectingJoltage.Count = 1 Then
		      ButtonMin(ButtonsAffectingJoltage(0)) = Joltage(JoltageIndex)
		      ButtonMax(ButtonsAffectingJoltage(0)) = Joltage(JoltageIndex)
		    ElseIf ButtonsAffectingJoltage.Count > 1 Then
		      For Each Index As Integer In ButtonsAffectingJoltage
		        If ButtonMax(Index) > 0 Then
		          ButtonMax(Index) = Min(ButtonMax(Index), Joltage(JoltageIndex))
		        Else
		          ButtonMax(Index) = Joltage(JoltageIndex)
		        End If
		      Next
		      
		    End If
		    
		  Next
		  
		  For i as integer = 0 to buttonmin.lastindex
		    Print(i.tostring + " " + buttonmin(i).tostring + "-" + buttonmax(i).tostring)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TestJoltageButtonPushCounts(pushCounts() As Integer) As Boolean
		  Var ButtonIndices() As Integer
		  For Index As Integer = 0 to pushCounts.LastIndex
		    For Push As Integer = 1 to pushCounts(Index)
		      ButtonIndices.Add(Index)
		    Next
		  Next
		  Return TestJoltageButtons(ButtonIndices)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TestJoltageButtons(ButtonIndices() As Integer) As Boolean
		  Var State() As Integer
		  State.ResizeTo(Joltage.LastIndex)
		  For Each ButtonIndex As Integer In ButtonIndices
		    For Each LightIndex As Integer In Buttons(ButtonIndex).Light
		      State(LightIndex) = State(LightIndex) + 1
		    Next
		  Next
		  For Index As Integer = 0 To Joltage.LastIndex
		    If State(Index) <> Joltage(Index) Then Return False
		  Next
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TestLightButtons(ButtonIndices() As Integer) As Boolean
		  Var State() As Boolean
		  State.ResizeTo(Light.LastIndex)
		  For Each ButtonIndex As Integer In ButtonIndices
		    For Each LightIndex As Integer In Buttons(ButtonIndex).Light
		      State(LightIndex) = Not State(LightIndex)
		    Next
		  Next
		  For Index As Integer = 0 To Light.LastIndex
		    If State(Index) <> Light(Index) Then Return False
		  Next
		  Return True
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Buttons() As Button
	#tag EndProperty

	#tag Property, Flags = &h0
		Count As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Joltage() As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  For Index As Integer = 0 To Joltage.LastIndex
			    If Joltage(Index) > 0 Then Return False
			  Next
			  Return True
			End Get
		#tag EndGetter
		JoltageAllZero As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Light() As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  For Index As Integer = 0 To Light.LastIndex
			    If Light(Index) Then Return False
			  Next
			  Return True
			End Get
		#tag EndGetter
		LightsAllOff As Boolean
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Count"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LightsAllOff"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="JoltageAllZero"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
