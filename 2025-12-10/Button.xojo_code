#tag Class
Protected Class Button
	#tag Method, Flags = &h0
		Sub Constructor(value As String)
		  value = value.Trim("(", ")")
		  Var Elements() As String = value.ToArray(",")
		  Count = Elements.Count
		  Light.ResizeTo(Elements.LastIndex)
		  For Index As Integer = 0 To Light.LastIndex
		    Light(Index) = Elements(Index).Trim.ToInteger
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Var Elements() As String
		  For Each Index As Integer In Light
		    Elements.Add(Index.ToString)
		  Next
		  Return "(" + String.FromArray(Elements, ",") + ")"
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Count As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Light() As Integer
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
			Name="Count"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
