#tag Class
Protected Class Tile
	#tag Method, Flags = &h0
		Sub Constructor(x As Integer, y As Integer)
		  Self.X = x
		  Self.Y = y
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FromString(coordinates As String) As Tile
		  Var XY() As String = coordinates.ToArray(",")
		  Return New Tile(XY(0).ToInteger, XY(1).ToInteger)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return X.ToString + "," + Y.ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UnionArea(other As Tile) As Integer
		  // These are objects so the width/height of a single point is 1 not 0
		  Var Width As Integer = Max(X, other.X) - Min(X, other.X) + 1
		  Var Height As Integer = Max(Y, other.Y) - Min(Y, other.Y) + 1
		  Return Width * Height
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		X As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Y As Integer
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
