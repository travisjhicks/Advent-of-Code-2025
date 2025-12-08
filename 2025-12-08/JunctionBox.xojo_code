#tag Class
Protected Class JunctionBox
	#tag Method, Flags = &h0
		Sub Constructor(x As Integer, y As Integer, z As Integer)
		  Self.X = x
		  Self.Y = y
		  Self.Z = z
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DistanceTo(other As JunctionBox) As Double
		  Return Sqrt(Pow(X - other.X, 2.0) + Pow(Y - other.Y, 2.0) + Pow(Z - other.Z, 2.0))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FromString(coordinates As String) As JunctionBox
		  Var Parts() As String = coordinates.ToArray(",")
		  Return New JunctionBox(Parts(0).ToInteger, Parts(1).ToInteger, Parts(2).ToInteger)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return X.ToString + "," + Y.ToString + "," + Z.ToString
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		X As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Y As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Z As Integer
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
			Name="X"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
