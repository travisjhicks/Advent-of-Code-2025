#tag Class
Protected Class Device
	#tag Method, Flags = &h0
		Sub Connect(names() As String)
		  For Each DeviceName As String In names
		    Var Dev As Device = Lookup(DeviceName)
		    If Connections.IndexOf(Dev) < 0 Then Connections.Add(Dev)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor(name As String)
		  Self.Name = name
		  PathsToCache = New Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function CountPaths(startDevice As String, targetDevice As String) As Integer
		  Return Lookup(startDevice).PathsTo(Lookup(targetDevice))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function HasDevice(name As String) As Boolean
		  Return Devices <> Nil And Devices.HasKey(name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Lookup(name As String) As Device
		  If Devices = Nil Then Devices = New Dictionary
		  If Not Devices.HasKey(name) Then Devices.Value(name) = New Device(name)
		  Return Devices.Value(name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PathsTo(targetDevice As Device) As UInt64
		  // Try to return from cache
		  If PathsToCache.HasKey(targetDevice) Then
		    Return PathsToCache.Value(targetDevice)
		  End If
		  
		  // Compute paths to target and cache result
		  Var Paths As UInt64
		  For Each Child As Device In Connections
		    Paths = Paths + If(Child Is targetDevice, 1, Child.PathsTo(targetDevice))
		  Next
		  PathsToCache.Value(targetDevice) = Paths
		  Return Paths
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Connections() As Device
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared Devices As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private PathsToCache As Dictionary
	#tag EndProperty


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
			Name="Name"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
