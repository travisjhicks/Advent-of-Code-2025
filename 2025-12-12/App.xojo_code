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
		  
		  
		  
		  ///// PART 2 /////
		  
		  
		  
		  Return 0
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub ReadFile(name As String)
		  // Read all devices and connections
		  Var Stream As TextInputStream = TextInputStream.Open(New FolderItem(name))
		  Do Until Stream.EndOfFile
		    // Stream.ReadLine.Trim.ToArray(": ")
		    
		  Loop
		End Sub
	#tag EndMethod


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
