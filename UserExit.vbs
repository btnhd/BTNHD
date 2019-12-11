Function UserExit(sType, sWhen, sDetail, bSkip)
	oLogging.CreateEntry "entered UserExit ", LogTypeInfo
	UserExit = Success
End Function
Function GetOfflineComputername()
On Error Goto 0
	If oEnvironment.Item("OSVERSION")="WinPE" Then
		Dim CompName : CompName = ""
		Dim ret, sOldSystem : sOldSystem = ""
		For Each drv In Array("C", "D", "E", "F")
			If ofso.FileExists(drv & ":\windows\system32\config\system") Then
				sOldSystem = drv & ":\windows\system32\config\system"
				Exit For
			End If
		Next
		oLogging.CreateEntry "Mounting Offline registry " & sOldSystem, LogTypeInfo
		ret = oShell.Run ("reg load HKLM\z " & sOldSystem, 0, True)
		If ret = 0 Then
			CompName = oShell.RegRead("HKLM\z\ControlSet001\Services\Tcpip\Parameters\Hostname")
			If CompName <> "" Then
				oLogging.CreateEntry "Found old computername '" & CompName & "'", LogTypeInfo
			Else
				oLogging.CreateEntry "Old computername name could not be found", LogTypeWarning
			End If
		Else
			oLogging.CreateEntry "Could not mount offline registry " & sOldSystem, LogTypeWarning
		End If
		oShell.Run "REG UNLOAD HKLM\Z", 0, True		
	Else
		CompName = oShell.ExpandEnvironmentStrings("%Computername%")
	End If
	GetOfflineComputername = CStr(CompName)
		
End Function