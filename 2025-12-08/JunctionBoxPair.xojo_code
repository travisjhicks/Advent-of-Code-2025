#tag Class
Protected Class JunctionBoxPair
	#tag Method, Flags = &h0
		Shared Function CompareDistance(pair1 As JunctionBoxPair, pair2 As JunctionBoxPair) As Integer
		  Return pair1.Distance - pair2.Distance
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(box1 As JunctionBox, box2 As JunctionBox)
		  Self.Box1 = box1
		  Self.Box2 = box2
		  Self.Distance = box1.DistanceTo(box2)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Box1 As JunctionBox
	#tag EndProperty

	#tag Property, Flags = &h0
		Box2 As JunctionBox
	#tag EndProperty

	#tag Property, Flags = &h0
		Distance As Double
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
			Name="Box1"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
