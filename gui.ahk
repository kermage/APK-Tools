GUI:
	Gui, -DPIScale
	Gui, Font, % "s" 12/DPI "w" 350*FSize, Verdana
	Gui, Add, Text, x10 y10 gSELECT vSELECT, Project
	Gui, Add, Text, x+10, :
	Gui, Add, Text, x+10 w290 cRed vprojname, %projname%
	Gui, Font, % "s" 6/DPI
	Gui, Add, Button, x313 y41 w75 h15 gAbout vAbout, About
	Gui, Font, % "s" 7/DPI "w" 200*FSize
	Gui, Add, Edit, x10 y285 w379 h165 HScroll cBlue ReadOnly vLogBox
	Gui, Add, Progress, x10 y+10 w379 h15 -Smooth vProgressBar
	Gui, Font, % "s" 10/DPI "w" 350*FSize, Verdana
	Gui, Add, Tab2, x1 y36 w400 h240 vTAB gTAB -wrap, %A_Space%Basics | Advanced| %A_Space%Tools %A_Space%| Settings
	Gui, Tab, 1
	Gui, Add, GroupBox, x10 y60 w380 h113 +Backgroundtrans
	Gui, Add, GroupBox, x10 y60 w380 h205 +Backgroundtrans
	Gui, Add, Button, x30 yp+23 w155 h30 gEXTRACT vEXTRACT, Extract
	Gui, Add, Button, x+30 w155 h30 gZIP vZIP, Zip
	Gui, Add, Button, x30 y+15 w340 h30 gOPTIMIZE vOPTIMIZE, Optimize Images
	Gui, Add, Radio, x70 y+29 cNavy Group gSIGNKEY vGENK Checked, Generated Key
	Gui, Add, Radio, x+35 cNavy gSIGNKEY vTEST, Test Keys
	Gui, Add, Button, x30 y+15 w155 h30 gSIGN vSIGN, Sign
	Gui, Add, Button, x+30 w155 h30 gZIPALIGN vZIPALIGN, Zipalign
	Gui, Tab, 2
	Gui, Add, GroupBox, x10 y60 w380 h205 +Backgroundtrans
	Gui, Add, Button, x30 yp+23 w155 h30 gDECOMPILE vDECOMPILE, Decompile
	Gui, Add, Button, x+30 w155 h30 gCOMPILE vCOMPILE, Compile
	Gui, Add, Button, x30 y+15 w340 h30 gINSTALL vINSTALL, ADB Install
	Gui, Add, Text, x75 y+16 gPLOC vPLOC, Location
	Gui, Add, Text, x145 yp, :
	Gui, Add, Text, x+10 w200 cNavy vapkloc, %apkloc%
	Gui, Add, Text, x75 y+5 gPNAME vPNAME, Name
	Gui, Add, Text, x145 yp, :
	Gui, Add, Text, x+10 w200 cNavy vapkname, %apkname%
	Gui, Add, Button, x30 yp+23 w155 h30 gPULL vPULL, ADB Pull
	Gui, Add, Button, x+30 w155 h30 gPUSH vPUSH, ADB Push
	Gui, Tab,3
	Gui, Add, GroupBox, x10 y60 w380 h205 +Backgroundtrans
	Gui, Add, Button, x30 yp+23 w340 h30 gFRAMEWORK vFRAMEWORK, Install Framework
	Gui, Add, Text, x75 y+19 gKOWN vKOWN, Owner Name
	Gui, Add, Text, x195 yp, :
	Gui, Add, Text, x+10 w155 cNavy vkeyown, %keyown%
	Gui, Add, Text, x75 y+5 gKNAME vKNAME, Keystore Name
	Gui, Add, Text, x195 yp, :
	Gui, Add, Text, x+10 w155 cNavy vkeyname, %keyname%
	Gui, Add, Text, x75 y+5 gKALIAS vKALIAS, Keystore Alias
	Gui, Add, Text, x195 yp, :
	Gui, Add, Text, x+10 w155 cNavy vkeyalias, %keyalias%
	Gui, Add, Text, x75 y+5 gKPASS vKPASS, Keystore Pass
	Gui, Add, Text, x195 yp, :
	Gui, Add, Text, x+10 w155 cNavy vkeypass, %keypass%
	Gui, Add, Button, x30 yp+23 w340 h30 gGENKEY vGENKEY, Generate Private Key
	Gui, Tab, 4
	Gui, Add, GroupBox, x10 y111 w380 h95 +Backgroundtrans
	Gui, Add, GroupBox, x10 y60 w380 h205 +Backgroundtrans
	Gui, Add, Text, x40 yp+23, Decompile?
	Gui, Add, Text, x85 y+35, Compression Level
	Gui, Add, Text, x+70, Heap Size
	Gui, Add, Text, x345 y+16, MB
	Gui, Add, Text, x137 y+30, APKTOOL Settings
	Gui, Add, Radio, x40 y+10 cNavy Group gAVER vNEW Checked, 2.0.0b9
	Gui, Add, Radio, x+50 cNavy gAVER vOLD, 1.5.2
	Gui, Add, Checkbox, x280 yp gDM vVERBOSE, Verbose
	Gui, Font, cNavy
	Gui, Add, Checkbox, x160 y85 Checked gDM vSOURCES, Sources
	Gui, Add, Checkbox, x+20 Checked gDM vRESOURCES, Resources
	Gui, Add, Text, x30 y+65, APK
	Gui, Add, DropDownList, x+10 yp-3 w70 gCL vACLS, NONE|LOW|FAST|NORM|MAX|ULTRA||
	Gui, Add, Text, x+15 yp+3, .arsc
	Gui, Add, DropDownList, x+10 yp-3 w70 gCL vRCLS, NONE||LOW|FAST|NORM|MAX|ULTRA|
	Gui, Add, Edit, x+20 w50 Limit4 vHS HWNDhEdit, %hs%
	Gui, Show, w400 h485 Center, %TITLE% v%VERSION%
return

GuiDropFiles:
	Loop, parse, A_GuiEvent, `n
	{
		dropfile = %A_LoopField%
		break
	}
	SplitPath, dropfile, dropname, droppath, dropext
	If (dropext = "apk") OR (dropext = "jar")
	{
		projpath := dropfile
		projname := dropname
		apkname := projname
		GuiControl, , projname, %projname%
		GuiControl, , apkname, %projname%
	}
	Else
		MsgBox, 262160, %TITLE% v%VERSION%, Invalid File
return

Button:
	Gui +OwnDialogs
	Var := (!Disable ? 0 : 1)
	GuiControl, 1: Enable%Var%, SELECT
	GuiControl, 1: Enable%Var%, EXTRACT
	GuiControl, 1: Enable%Var%, ZIP
	GuiControl, 1: Enable%Var%, OPTIMIZE
	GuiControl, 1: Enable%Var%, GENK
	GuiControl, 1: Enable%Var%, TEST
	GuiControl, 1: Enable%Var%, SIGN
	GuiControl, 1: Enable%Var%, ZIPALIGN
	GuiControl, 1: Enable%Var%, DECOMPILE
	GuiControl, 1: Enable%Var%, COMPILE
	GuiControl, 1: Enable%Var%, INSTALL
	GuiControl, 1: Enable%Var%, PLOC
	GuiControl, 1: Enable%Var%, apkloc
	GuiControl, 1: Enable%Var%, PNAME
	GuiControl, 1: Enable%Var%, apkname
	GuiControl, 1: Enable%Var%, PULL
	GuiControl, 1: Enable%Var%, PUSH
	GuiControl, 1: Enable%Var%, FRAMEWORK
	GuiControl, 1: Enable%Var%, KOWN
	GuiControl, 1: Enable%Var%, keyown
	GuiControl, 1: Enable%Var%, KNAME
	GuiControl, 1: Enable%Var%, keyname
	GuiControl, 1: Enable%Var%, KALIAS
	GuiControl, 1: Enable%Var%, keyalias
	GuiControl, 1: Enable%Var%, KPASS
	GuiControl, 1: Enable%Var%, keypass
	GuiControl, 1: Enable%Var%, GENKEY
	GuiControl, 1: Enable%Var%, SOURCES
	GuiControl, 1: Enable%Var%, RESOURCES
	GuiControl, 1: Enable%Var%, ACLS
	GuiControl, 1: Enable%Var%, RCLS
	GuiControl, 1: Enable%Var%, HS
	GuiControl, 1: Enable%Var%, NEW
	GuiControl, 1: Enable%Var%, OLD
	GuiControl, 1: Enable%Var%, VERBOSE
	Disable := !Disable
	IfWinExist, VERBOSE LOG
	{
		GuiControl, 5: Enable%Var%, Save
		GuiControl, 5: Enable%Var%, Close
		SendMessage, 0x0115, 7, 0,, ahk_id %hDebugLog%
	}
return

UpdateLog(Message, Timestamp="y", Output="y")
{
	global LogFile
	AutoTrim, Off
	FormatTime, LogTime, %A_Now%, HH:mm:ss
	LogText = %Message%`n
	If Timestamp = y
		LogText = %LogTime%`t-`t%LogText%
	FileAppend, %LogText%, %LogFile%
	If Output = y
	{
		GuiControlGet, LogBox, 1:, LogBox
		LogText = %Message%`n
		If Timestamp = y
			LogText = %LogTime% - %LogText%
		GuiControl, 1:,LogBox, %LogText%%LogBox%
	}
	AutoTrim, On
}

Progress(n)
{
	global TempFile, DebugLog
	If n = 1
	{
		DebugLog = 
		FileDelete, %TempFile%
		SetTimer, ProgressBar
	}
	If n = 0
	{
		SetTimer, ProgressBar, Off
		GuiControl, 1:, ProgressBar, 0
		Progress, OFF
		FileRead, DebugLog, %TempFile%
		If DebugLog
		{
			IfWinNotExist, VERBOSE LOG
				GoSub, VerbLog
			GuiControl, 5:, DebugLog, %DebugLog%
		}
	}
}

ProgressBar:
	SetTimer, ProgressBar, Off
	FileRead, DebugLog, %TempFile%
	If DebugLog
	{
		IfWinNotExist, VERBOSE LOG
			GoSub, VerbLog
		If (DebugLog != PrevLog)
		{
			GuiControl, 5:, DebugLog, %DebugLog%
			SendMessage, 0x0115, 7, 0,, ahk_id %hDebugLog%
			PrevLog := DebugLog
		}
	}
	Bar := (!Full ? 1 : 50)
	GuiControl, 1:, ProgressBar, %Bar%
	Sleep % Bar
	GuiControl, 1:, ProgressBar, 100
	Sleep % Bar*6
	Full := !Full
	SetTimer, ProgressBar
return

VerbLog:
	Gui, +LastFound
	WinGetPos, x, y, w, h
	PosX := x + w + 10
	Gui, 5: -SysMenu +Resize -DPIScale
	Gui, 5: Font, % "s" 7/DPI
	Gui, 5: Add, Button, x30 y10 w160 h20 Disabled gSave vSave, Save
	Gui, 5: Add, Button, x+30 w160 h20 Disabled gClose vClose, Close
	Gui, 5: Add, Edit, x0 y+10 w400 h250 HScroll cGreen ReadOnly hwndhDebugLog vDebugLog, %DebugLog%
	Gui, 5: Show, x%PosX% y%y%, VERBOSE LOG
return

Save:
FileSelectFile, selectfile, S16, %DIR%\Logs\Debug.log, Save Log File, Log File (*.log)
If !ErrorLevel
{
	SplitPath, selectfile, selectname, selectpath, selectext
	If !selectext
		selectfile = %selectfile%.log
	FileDelete %selectfile%
	FileAppend, %DebugLog%, %selectfile%
	Run, Notepad %selectfile%
}
return

Close:
5GuiClose:
	Gui, 5: Destroy
return

5GuiSize:
If ErrorLevel
    return
NewWidth := A_GuiWidth
NewHeight := A_GuiHeight - 40
GuiControl, Move, DebugLog, W%NewWidth% H%NewHeight%
return

About:
	Gui, 2: -MinimizeBox -MaximizeBox -DPIScale
	;@Ahk2Exe-IgnoreBegin
	Gui, 2: Add, Picture, x10 y10 w32 h32, PrivaTech.ico
	;@Ahk2Exe-IgnoreEnd
	/*@Ahk2Exe-Keep
	Gui, 2: Add, Picture, x10 y10 w32 h32, %A_ScriptName%
	*/
	Gui, 2: Font, % "s" 12/DPI "w" 350*FSize, Verdana
	Gui, 2: Add, Text, x53 y10, %TITLE% v%VERSION%
	Gui, 2: Font, % "s" 8/DPI
	Gui, 2: Add, Text, xp y+5, By:%A_Space%
	Gui, 2: Add, Text, x+0 cBlue gLink vLink, PrivaTech -- GAFT
	Gui, 2: Show, Center, About
	GuiControl, 1: Disable, About
return

2GuiClose:
2GuiEscape:
	Gui, 2: Destroy
	GuiControl, 1: Enable, About
return

Link:
	Run, http://goo.gl/l3NfAS
return

GuiClose:
GuiEscape:
	UpdateLog("Session Ended!") 
ExitApp
