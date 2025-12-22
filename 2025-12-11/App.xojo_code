#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // Read input file
		  Try
		    ReadFile(args(1))
		  Catch
		    Print("Error reading input file.")
		    Return 0
		  End Try
		  
		  ///// PART 1 /////
		  
		  If Device.HasDevice("you") Then
		    Var Paths As Integer = Device.CountPaths("you", "out")
		    Print("[PART 1] Paths from 'you' to 'out': " + Paths.ToString)
		  End If
		  
		  ///// PART 2 /////
		  
		  If Device.HasDevice("svr") Then
		    Var Paths As Integer = _
		    Device.CountPaths("svr", "dac") * Device.CountPaths("dac", "fft") * Device.CountPaths("fft", "out") + _
		    Device.CountPaths("svr", "fft") * Device.CountPaths("fft", "dac") * Device.CountPaths("dac", "out")
		    Print("[PART 2] Paths from 'svr' to 'out' that include 'dac' and 'fft': " + Paths.ToString)
		  End If
		  
		  Return 0
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub ReadFile(name As String)
		  // Read all devices and connections
		  Var Stream As TextInputStream = TextInputStream.Open(New FolderItem(name))
		  Do Until Stream.EndOfFile
		    Var Parts() As String = Stream.ReadLine.Trim.ToArray(": ")
		    Var DeviceName As String = Parts(0)
		    Var Connections() As String = Parts(1).ToArray(" ")
		    Device.Lookup(DeviceName).Connect(Connections)
		  Loop
		End Sub
	#tag EndMethod


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
