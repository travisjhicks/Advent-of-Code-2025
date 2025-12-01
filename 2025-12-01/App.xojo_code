#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  Var ZeroCount As Integer
		  Var ZeroPassThrough As Integer
		  Var Arrow As Integer = INITIAL_STATE
		  Var Lines() As String
		  
		  Try
		    Var Input As TextInputStream = TextInputStream.Open(New FolderItem(args(1)))
		    Lines = Input.ReadAll.ReplaceLineEndings(EndOfLine).Trim.ToArray(EndOfLine)
		  Catch
		    Print("Error reading file.")
		    Return 0
		  End Try
		  
		  For Each Line As String In Lines
		    Var Direction As String = Line.Left(1)
		    Var Distance As Integer = Line.Middle(1).ToInteger
		    Select Case Direction
		    Case "L"
		      If Arrow = 0 Then
		        ZeroPassThrough = ZeroPassThrough + Distance \ VALUES
		        Arrow = Arrow - Distance
		        While Arrow < 0
		          Arrow = Arrow + VALUES
		        Wend
		      Else
		        Arrow = Arrow - Distance
		        While Arrow < 0
		          Arrow = Arrow + VALUES
		          ZeroPassThrough = ZeroPassThrough + 1
		        Wend
		        If Arrow = 0 Then ZeroPassThrough = ZeroPassThrough + 1
		      End If
		    Case "R"
		      ZeroPassThrough = ZeroPassThrough + (Arrow + Distance) \ VALUES
		      Arrow = (Arrow + Distance) Mod VALUES
		    Else
		      Print("Invalid rotation argument: " + Line)
		      Return 0
		    End Select
		    If Arrow = 0 Then ZeroCount = ZeroCount + 1
		  Next
		  
		  Print("Password: " + ZeroCount.ToString)
		  Print("Method 0x434C49434B: " + ZeroPassThrough.ToString)
		  Return 0
		End Function
	#tag EndEvent


	#tag Constant, Name = INITIAL_STATE, Type = Double, Dynamic = False, Default = \"50", Scope = Private
	#tag EndConstant

	#tag Constant, Name = VALUES, Type = Double, Dynamic = False, Default = \"100", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
