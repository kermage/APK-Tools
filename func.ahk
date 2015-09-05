SELECT:
	ToolTip
	GoSub, Button
	FileSelectFile, selectfile, 3, %DIR%\APK Files, Select APK / JAR, (*.apk; *.jar)
	If !ErrorLevel
	{
		SplitPath, selectfile, selectname, selectpath, selectext
		If (selectext = "apk") OR (selectext = "jar")
		{
			projpath := selectfile
			projname := selectname
			apkname := projname
			GuiControl, , projname, %projname%
			GuiControl, , apkname, %apkname%
		}
		Else
			MsgBox, 262160, %TITLE%, Invalid File
	}
	GoSub, Button
return

EXTRACT:
	GoSub, Button
	If !projname
	{
		MsgBox, 262160, %TITLE%, Select a project first
		GoSub, Button
		return
	}
	UpdateLog("Extracting " projname)
	Progress(1)
	RunWait, %comspec% /C "ECHO|SET /P ="Clearing Projects\%projname% . . . " >> "%TempFile%" & rmdir /S /Q "%DIR%\Projects\%projname%" & ECHO DONE^! >> "%TempFile%"",, Hide
	RunWait, %comspec% /C ""%DIR%\tools\7za.exe" x -o"%DIR%\Projects\%projname%" "%projpath%" >> "%TempFile%" 2<&1",, Hide
	If ErrorLevel
		UpdateLog("ERROR!")
	Else
	{
		FileAppend, , %DIR%\Projects\%projname%\EXTRACTED
		UpdateLog("DONE!")
	}
	Progress(0)
	GoSub, Button
return

ZIP:
	GoSub, Button
	If !projname
	{
		MsgBox, 262160, %TITLE%, Select a project first
		GoSub, Button
		return
	}
	IfNotExist, %DIR%\Projects\%projname%\EXTRACTED
	{
		MsgBox, 262160, %TITLE%, Extract %projname% first
		GoSub, Button
		return
	}
	UpdateLog("Zipping " projname)
	Progress(1)
	RunWait, %comspec% /C "ECHO Preparing Projects\%projname% . . . >> "%TempFile%" & DEL /Q "%DIR%\Projects\%projname%\EXTRACTED" & DEL /Q "%DIR%\OUTPUT\%projname%"",, Hide
	RunWait, %comspec% /C ""%DIR%\tools\7za.exe" x -o"%DIR%\Projects\%projname%" "%projpath%" META-INF -r -y >> "%TempFile%" 2<&1",, Hide
	If ErrorLevel
	{
		Progress(0)
		UpdateLog("ERROR!")
		FileAppend, , %DIR%\Projects\%projname%\EXTRACTED
		GoSub, Button
		return
	}
	RunWait, %comspec% /C ""%DIR%\tools\7za.exe" a -tzip "%DIR%\OUTPUT\%projname%" "%DIR%\Projects\%projname%\*" -mx%acl% >> "%TempFile%" 2<&1",, Hide
	If ErrorLevel
		UpdateLog("ERROR!")
	Else
		UpdateLog("DONE!")
	FileAppend, , %DIR%\Projects\%projname%\EXTRACTED
	Progress(0)
	GoSub, Button
return

OPTIMIZE:
	GoSub, Button
	If !projname
	{
		MsgBox, 262160, %TITLE%, Select a project first
		GoSub, Button
		return
	}
	IfNotExist, %DIR%\Projects\%projname%
	{
		MsgBox, 262160, %TITLE%, Extract / Decompile %projname% first
		GoSub, Button
		return
	}
	UpdateLog("Optimizing " projname)
	Progress(1)			
	RunWait, %comspec% /C "ECHO Preparing %projname% . . . >> "%TempFile%" & ECHO. >> "%TempFile%" & rmdir /S /Q "%DIR%\Projects\temp.%projname%"",, Hide
	FileCreateDir, %DIR%\Projects\temp.%projname%
	RunWait, %comspec% /C "xcopy "%DIR%\Projects\%projname%\res\*.9.png" "%DIR%\Projects\temp.%projname%" /S /Y >> "%TempFile%" 2<&1",, Hide
	If ErrorLevel
	{
		Progress(0)
		UpdateLog("ERROR!")
		GoSub, Button
		return
	}
	RunWait, %comspec% /C "ECHO. >> "%TempFile%" & ECHO Optimizing %projname% . . . >> "%TempFile%" & ECHO. >> "%TempFile%" & "%DIR%\tools\roptipng.exe" -o99 "%DIR%\Projects\%projname%\**\*.png" >> "%TempFile%" 2<&1",, Hide
	If ErrorLevel
	{
		Progress(0)
		UpdateLog("ERROR!")
		GoSub, Button
		return
	}
	RunWait, %comspec% /C "ECHO. >> "%TempFile%" & ECHO Finalizing %projname% . . . >> "%TempFile%" & ECHO. >> "%TempFile%" & xcopy "%DIR%\Projects\temp.%projname%" "%DIR%\Projects\%projname%\res" /S /Y >> "%TempFile%" 2<&1",, Hide
	If ErrorLevel
		UpdateLog("ERROR!")
	Else
	{
		RunWait, %comspec% /C "rmdir /S /Q "%DIR%\Projects\temp.%projname%"",, Hide
		UpdateLog("DONE!")
	}
	Progress(0)
	GoSub, Button
return

SIGNKEY:
	Gui, Submit, NoHide
	If GENK = 1
		signkey = GEN
	If TEST = 1
		signkey = TEST
return

SIGN:
	GoSub, Button
	FileSelectFile, selectfile, 3, %DIR%\OUTPUT, Select APK / Zip, (*.apk; *.zip)
	If !ErrorLevel
	{
		SplitPath, selectfile, selectname, selectpath, selectext
		If (selectext = "apk") OR (selectext = "zip")
		{
			signpath := selectfile
			signname := selectname
			If signkey = GEN
				Goto, GEN
			UpdateLog("Signing " signname " with Test Keys (General Signature)")
			Progress(1)
			RunWait, %comspec% /C "java -Xmx%hs%m -jar "%DIR%\tools\signapk.jar" -w "%DIR%\tools\testkey.x509.pem" "%DIR%\tools\testkey.pk8" "%signpath%" "%DIR%\OUTPUT\tksigned-%signname%" >> "%TempFile%" 2<&1",, Hide
			If ErrorLevel
				UpdateLog("ERROR!")
			Else
				UpdateLog("DONE!")
			Progress(0)
		}
		Else
			MsgBox, 262160, %TITLE%, Invalid File
	}
	GoSub, Button
return

GEN:
	Gui, 3: -MinimizeBox -MaximizeBox -DPIScale
	Gui, 3: Font, % "s" 8/DPI "w" 350*FSize, Verdana
	Gui, 3:	Add, Text, x10 y15 cRed gKPATH vKPATH, Click here to select keystore
	Gui, 3: Add, Text, x10 y+15, Key Alias
	Gui, 3: Add, Text, x120 yp, :
	Gui, 3: Add, Edit, x+10 yp-3 w100 Limit10 vinputalias
	Gui, 3: Add, Text, x10 y+5, Store Password
	Gui, 3: Add, Text, x120 yp, :
	Gui, 3: Add, Edit, x+10 yp-3 w100 Limit10 vinputpass
	Gui, 3: Add, Text, x10 y+5, Key Password
	Gui, 3: Add, Text, x120 yp, :
	Gui, 3: Add, Edit, x+10 yp-3 w100 Limit10 vinputpass2
	Gui, 3:	Add, Button, x10 y+10 w225 h25 Default, Submit
	Gui, 3: Show, Center, Enter Keystore Details
	return
	KPATH:
		FileSelectFile, selectfile, 3, %DIR%\OUTPUT, Select KeyStore, (*.keystore)
		If !ErrorLevel
		{
			SplitPath, selectfile, selectname, selectpath, selectext
			If (selectext = "keystore")
			{
				storepath := selectfile
				storename := selectname
				GuiControl, 3:, KPATH, %storename%
			}
			Else
				MsgBox, 262160, %TITLE%, Invalid File
		}				
	return
	3ButtonSubmit:
		Gui, 3: Submit
		If (storename) AND (inputalias) AND (inputpass) AND (inputpass2)
		{
			UpdateLog("Signing " signname " with " storename)
			Progress(1)
			RunWait, %comspec% /C "ECHO Signing %signpath% . . . >> "%TempFile%" & ECHO. >> "%TempFile%" & jarsigner -keystore "%storepath%" -storepass "%inputpass%" -keypass "%inputpass2%" -signedjar "%DIR%\OUTPUT\gpsigned-%signname%" "%signpath%" "%inputalias%" >> "%TempFile%"",, Hide
			If ErrorLevel
				UpdateLog("ERROR!")
			Else
				UpdateLog("DONE!")
			Progress(0)
		}
		Else
			MsgBox, 262160, %TITLE%, Enter private key details first			
	3GuiClose:
	3GuiEscape:
		Gui 3: Destroy
	GoSub, Button
return

ZIPALIGN:
	GoSub, Button
	FileSelectFile, selectfile, 3, %DIR%\OUTPUT, Select APK / Zip, (*.apk; *.zip)
	If !ErrorLevel
	{
		SplitPath, selectfile, selectname, selectpath, selectext
		If (selectext = "apk") OR (selectext = "zip")
		{
			UpdateLog("Zipaligning " selectname)
			Progress(1)
			RunWait, %comspec% /C ""%DIR%\tools\zipalign.exe" -f 4 "%selectfile%" "%DIR%\OUTPUT\aligned-%selectname%" >> "%TempFile%" 2<&1",, Hide
			If ErrorLevel
				UpdateLog("ERROR!")
			Else
			{
				FileDelete, %DIR%\OUTPUT\%selectname%
				FileMove, %DIR%\OUTPUT\aligned-%selectname%, %DIR%\OUTPUT\%selectname%, 1
				UpdateLog("DONE!")
			}
			Progress(0)
		}
		Else
			MsgBox, 262160, %TITLE%, Invalid File
	}
	GoSub, Button
return

DECOMPILE:
	GoSub, Button
	If !projname
	{
		MsgBox, 262160, %TITLE%, Select a project first
		GoSub, Button
		return
	}
	framtag =
	InputBox, framtag, Framework Tagname, Cancel to Use Default Frameworks, , 250, 125
	UpdateLog("Decompiling " projname " - " dms)
	Progress(1)
	RunWait, %comspec% /C "ECHO|SET /P ="Clearing Projects\%projname% . . . " >> "%TempFile%" & rmdir /S /Q "%DIR%\Projects\%projname%" & ECHO DONE^! >> "%TempFile%"",, Hide
	If !framtag
	{
		If (apkver = "2.0.0b9")
			RunWait, %comspec% /C "ECHO. >> "%TempFile%" & java -Xmx%hs%m -jar "%DIR%\tools\apktool%apkver%.jar" %dm% -p "%DIR%\tools\Frameworks\%apkver%" "%projpath%" -o "%DIR%\Projects\%projname%" >> "%TempFile%" 2<&1",, Hide
		Else If (apkver = "1.5.2")
			RunWait, %comspec% /C "ECHO. >> "%TempFile%" & java -Xmx%hs%m -jar "%DIR%\tools\apktool%apkver%.jar" %dm% --frame-path "%DIR%\tools\Frameworks\%apkver%" "%projpath%" "%DIR%\Projects\%projname%" >> "%TempFile%" 2<&1",, Hide
	}
	Else
	{
		If (apkver = "2.0.0b9")
			RunWait, %comspec% /C "ECHO. >> "%TempFile%" & java -Xmx%hs%m -jar "%DIR%\tools\apktool%apkver%.jar" %dm% -p "%DIR%\tools\Frameworks\%apkver%" -t "%framtag%" "%projpath%" -o "%DIR%\Projects\%projname%" >> "%TempFile%" 2<&1",, Hide
		Else If (apkver = "1.5.2")
			RunWait, %comspec% /C "ECHO. >> "%TempFile%" & java -Xmx%hs%m -jar "%DIR%\tools\apktool%apkver%.jar" %dm% --frame-path "%DIR%\tools\Frameworks\%apkver%" --frame-tag "%framtag%" "%projpath%" "%DIR%\Projects\%projname%" >> "%TempFile%" 2<&1",, Hide
	}
	If ErrorLevel
		UpdateLog("ERROR!")
	Else
		UpdateLog("DONE!")
	FileAppend, , %DIR%\Projects\%projname%\DECOMPILED
	Progress(0)
	GoSub, Button
return

COMPILE:
	GoSub, Button
	If !projname
	{
		MsgBox, 262160, %TITLE%, Select a project first
		GoSub, Button
		return
	}
	IfNotExist, %DIR%\Projects\%projname%\DECOMPILED
	{
		MsgBox, 262160, %TITLE%, Decompile %projname% first
		GoSub, Button
		return
	}
	Gui, 4: -SysMenu -DPIScale
	Gui, 4: Font, % "s" 8/DPI "w" 350*FSize "cNavy", Verdana
	Gui, 4: Add, Checkbox, x30 y10 vOS Checked, META-INF (Signature)
	Gui, 4: Add, Checkbox, y+10 vAM, AndroidManifest.xml
	Gui, 4: Add, Checkbox, y+10 vRA, Resources.arsc
	Gui, 4:	Add, Button, x10 y+10 w200 h25 Default, Continue
	Gui, 4: Show, Center, Copy over original...
	return
	4ButtonContinue:
		Gui, 4: Submit
	UpdateLog("Compiling " projname)
	Progress(1)
	RunWait, %comspec% /C "ECHO Preparing Projects\%projname% . . . >> "%TempFile%" & DEL /Q "%DIR%\Projects\%projname%\DECOMPILED" & DEL /Q "%DIR%\OUTPUT\%projname%"",, Hide
	RunWait, %comspec% /C "ECHO. >> "%TempFile%" & java -Xmx%hs%m -jar "%DIR%\tools\apktool%apkver%.jar" b -p "%DIR%\tools\Frameworks\%apkver%" -o "%DIR%\OUTPUT\%projname%" "%DIR%\Projects\%projname%" >> "%TempFile%" 2<&1",, Hide
	If ErrorLevel
	{
		Progress(0)
		UpdateLog("ERROR!")
		FileAppend, , %DIR%\Projects\%projname%\DECOMPILED
		GoSub, Button
		return
	}
	FileAppend, , %DIR%\Projects\%projname%\DECOMPILED
	UpdateLog("DONE!")
	If OS = 1
	{
		RunWait, %comspec% /C ""%DIR%\tools\7za.exe" x -o"%DIR%\Projects\%projname%\original" "%projpath%" META-INF -r -y >> "%TempFile%" 2<&1",, Hide
		If ErrorLevel
		{
			Progress(0)
			UpdateLog("ERROR!")
			GoSub, Button
			return
		}
		RunWait, %comspec% /C ""%DIR%\tools\7za.exe" a -tzip "%DIR%\OUTPUT\%projname%" "%DIR%\Projects\%projname%\original\META-INF" -mx%acl% >> "%TempFile%" 2<&1",, Hide
		If ErrorLevel
		{
			Progress(0)
			UpdateLog("ERROR!")
			GoSub, Button
			return
		}
		UpdateLog("Copied over original Signatures")
	}
	If AM = 1
	{
		RunWait, %comspec% /C ""%DIR%\tools\7za.exe" x -o"%DIR%\Projects\%projname%\original" "%projpath%" AndroidManifest.xml -r -y >> "%TempFile%" 2<&1",, Hide
		If ErrorLevel
		{
			Progress(0)
			UpdateLog("ERROR!")
			GoSub, Button
			return
		}
		RunWait, %comspec% /C ""%DIR%\tools\7za.exe" a -tzip "%DIR%\OUTPUT\%projname%" "%DIR%\Projects\%projname%\original\AndroidManifest.xml" -mx%acl% >> "%TempFile%" 2<&1",, Hide
		If ErrorLevel
		{
			Progress(0)
			UpdateLog("ERROR!")
			GoSub, Button
			return
		}
		UpdateLog("Copied over original AndroidManifest.xml")
	}
	If RA = 1
	{
		RunWait, %comspec% /C ""%DIR%\tools\7za.exe" x -o"%DIR%\Projects\%projname%\original" "%projpath%" resources.arsc -r -y >> "%TempFile%" 2<&1",, Hide
		If ErrorLevel
		{
			Progress(0)
			UpdateLog("ERROR!")
			GoSub, Button
			return
		}
		RunWait, %comspec% /C ""%DIR%\tools\7za.exe" a -tzip "%DIR%\OUTPUT\%projname%" "%DIR%\Projects\%projname%\original\resources.arsc" -mx%rcl% >> "%TempFile%" 2<&1",, Hide
		If ErrorLevel
		{
			Progress(0)
			UpdateLog("ERROR!")
			GoSub, Button
			return
		}
		UpdateLog("Copied over original resources.arsc")
	}
	4GuiClose:
	4GuiEscape:
		Gui 4: Destroy
	Progress(0)
	GoSub, Button
return

INSTALL:
	GoSub, Button
	FileSelectFile, selectfile, 3, %DIR%\OUTPUT, Select APK, (*.apk)
	If !ErrorLevel
	{
		SplitPath, selectfile, selectname, selectpath, selectext
		If (selectext = "apk")
		{
			UpdateLog("Installing " selectname)
			Progress(1)
			RunWait, %comspec% /C ""%DIR%\tools\adb.exe" devices >> "%TempFile%" 2<&1",, Hide
			RunWait, %comspec% /C ""%DIR%\tools\adb.exe" remount >> "%TempFile%" 2<&1",, Hide
			Run, %comspec% /C ""%DIR%\tools\adb.exe" install "%selectfile%" >> "%TempFile%" 2<&1",, Hide
			If ErrorLevel
				UpdateLog("ERROR!")
			Else
				UpdateLog("DONE!")
			Progress(0)
		}
		Else
			MsgBox, 262160, %TITLE%, Invalid File
	}
	GoSub, Button
return

PLOC:
	ToolTip
	GoSub, Button
	InputBox, inputloc, Enter APK Location, Example: /system/app/, , 250, 125, , , , , %apkloc%
	GoSub, Button
	apkloc := inputloc
	StringLeft, lslash, inputloc, 1
	If (lslash != "/")
		apkloc = /%apkloc%
	GuiControl, , apkloc, %apkloc%
return

PNAME:
	ToolTip
	GoSub, Button
	InputBox, inputname, Enter APK Name, Example: SystemUI.apk, , 250, 125, , , , , %apkname%
	GoSub, Button
	apkname := inputname
	StringRight, rslash, apkloc, 1
	If (rslash != "/")
	{
		apkloc = %apkloc%/
		GuiControl, , apkloc, %apkloc%
	}
	GuiControl, , apkname, %apkname%
return

PULL:
	GoSub, Button
	If !apkname
		UpdateLog("Pulling " apkloc " directory")
	Else
		UpdateLog("Pulling " apkloc apkname)
	Progress(1)
	RunWait, %comspec% /C ""%DIR%\tools\adb.exe" devices >> "%TempFile%" 2<&1",, Hide
	RunWait, %comspec% /C ""%DIR%\tools\adb.exe" remount >> "%TempFile%" 2<&1",, Hide
	RunWait, %comspec% /C ""%DIR%\tools\adb.exe" pull "%apkloc%%apkname%" "%DIR%\APK Files\%apkname%" >> "%TempFile%" 2<&1",, Hide
	If ErrorLevel
		UpdateLog("ERROR!")
	Else
		UpdateLog("DONE!")
	Progress(0)
	GoSub, Button
return

PUSH:
	GoSub, Button
	FileSelectFile, selectfile, 3, %DIR%\OUTPUT, Select File
	If !ErrorLevel
	{
		SplitPath, selectfile, selectname, selectpath, selectext
		apkname := selectname
		GuiControl, , apkname, %apkname%
		StringRight, rslash, apkloc, 1
		If (rslash != "/")
		{
			apkloc = %apkloc%/
			GuiControl, , apkloc, %apkloc%
		}
		UpdateLog("Pushing " apkloc apkname)
		Progress(1)
		RunWait, %comspec% /C ""%DIR%\tools\adb.exe" devices >> "%TempFile%" 2<&1",, Hide
		RunWait, %comspec% /C ""%DIR%\tools\adb.exe" remount >> "%TempFile%" 2<&1",, Hide
		RunWait, %comspec% /C ""%DIR%\tools\adb.exe" push "%selectfile%" "%apkloc%%apkname%" >> "%TempFile%" 2<&1",, Hide
		If ErrorLevel
			UpdateLog("ERROR!")
		Else
			UpdateLog("DONE!")
		Progress(0)
	}
	GoSub, Button
return

FRAMEWORK:
	GoSub, Button
	FileSelectFile, selectfile, 3, %DIR%\APK Files, Select Framework, (*.apk)
	If !ErrorLevel
	{
		SplitPath, selectfile, selectname, selectpath, selectext
		If (selectext = "apk")
		{
			frampath := selectfile
			framname := selectname
			framtag =
			InputBox, framtag, Framework Tagname, Cancel to Skip Framework Tagging, , 250, 125
		}
		Else
		{
			MsgBox, 262160, %TITLE%, Invalid File
			GoSub, Button
			return
		}
	}
	Else
	{
		GoSub, Button
		return
	}
	If !framtag
	{
		UpdateLog("Installing " framname)
		Progress(1)			
		If (apkver = "2.0.0b9")
			RunWait, %comspec% /C "java -jar "%DIR%\tools\apktool%apkver%.jar" %fi% "%frampath%" -p "%DIR%\tools\Frameworks\%apkver%" >> "%TempFile%" 2<&1",, Hide
		Else If (apkver = "1.5.2")
			RunWait, %comspec% /C "java -jar "%DIR%\tools\apktool%apkver%.jar" %fi% "%frampath%" --frame-path "%DIR%\tools\Frameworks\%apkver%" >> "%TempFile%" 2<&1",, Hide
		}
	Else
	{
		UpdateLog("Installing " framname " with " framtag " tag")
		Progress(1)			
		If (apkver = "2.0.0b9")
			RunWait, %comspec% /C "java -jar "%DIR%\tools\apktool%apkver%.jar" %fi% "%frampath%" -t "%framtag%" -p "%DIR%\tools\Frameworks\%apkver%" >> "%TempFile%" 2<&1",, Hide
		Else If (apkver = "1.5.2")
			RunWait, %comspec% /C "java -jar "%DIR%\tools\apktool%apkver%.jar" %fi% "%frampath%" "%framtag%" --frame-path "%DIR%\tools\Frameworks\%apkver%" >> "%TempFile%" 2<&1",, Hide
	}
	If ErrorLevel
		UpdateLog("ERROR!")
	Else
		UpdateLog("DONE!")
	Progress(0)
	GoSub, Button
return

KOWN:
	ToolTip
	GoSub, Button
	keyown =
	InputBox, keyown, Enter Owner Name, Example: Gene Torcende, , 250, 125
	GoSub, Button
	If ErrorLevel OR !keyown
		return
	GuiControl, , keyown, %keyown%
return

KNAME:
	ToolTip
	GoSub, Button
	keyname =
	InputBox, keyname, Enter Keystore Name, Example: APK Tools, , 250, 125
	GoSub, Button
	If ErrorLevel OR !keyname
		return
	GuiControl, , keyname, %keyname%
return

KALIAS:
	ToolTip
	GoSub, Button
	keyalias =
	InputBox, keyalias, Enter Keystore Alias, Example: apktools, , 250, 125
	GoSub, Button
	If ErrorLevel OR !keyalias
		return
	GuiControl, , keyalias, %keyalias%
return

KPASS:
	ToolTip
	GoSub, Button
	keypass =
	InputBox, keypass, Enter Keystore Pass, Example: 123456, , 250, 125
	GoSub, Button
	If ErrorLevel OR !keypass
		return
	GuiControl, , keypass, %keypass%
return

GENKEY:
	GoSub, Button
	If (!keyown) OR (!keyname) OR (!keyalias) OR (!keypass)
	{
		MsgBox, 262160, %TITLE%, Enter private key details first
		GoSub, Button
		return
	}
	UpdateLog("Generating " keyname ".keystore with " keyalias " alias")
	Progress(1)			
	RunWait, %comspec% /C "keytool -genkey -v -keystore "%DIR%\OUTPUT\%keyname%.keystore" -alias "%keyalias%" -keyalg RSA -keysize 2048 -dname "cn=%keyown%" -keypass "%keypass%" -validity 18263 -storepass "%keypass%" >> "%TempFile%" 2<&1",, Hide
	If ErrorLevel
		UpdateLog("ERROR!")
	Else
		UpdateLog("DONE!")
	Progress(0)
	GoSub, Button
return

CL:
	Gui, Submit, NoHide
	cl1 = 0
	cl2 = 1
	cl3 = 3
	cl4 = 5
	cl5 = 7
	cl6 = 9
	cls1 = NONE
	cls2 = LOW
	cls3 = FAST
	cls4 = NORM
	cls5 = MAX
	cls6 = ULTRA
	Loop, 6
	{
		If (cls%A_Index% = ACLS)
			acl := cl%A_Index%
		If (cls%A_Index% = RCLS)
			rcl := cl%A_Index%
	}
return

DM:
	Gui, Submit, NoHide
	m1 = d -r -s
	m2 = d -r
	m3 = d -s
	m4 = d
	ms1 = Raw Format Only 
	ms2 = Sources Only 
	ms3 = Resources Only 
	ms4 = Sources and Resources
	If ((RESOURCES = 0) AND (SOURCES = 0))
		d = 1
	If ((RESOURCES = 0) AND (SOURCES = 1))
		d = 2
	If ((RESOURCES = 1) AND (SOURCES = 0))
		d = 3
	If ((RESOURCES = 1) AND (SOURCES = 1))
		d = 4
	dm := m%d%
	dms := ms%d%
	fi = if
	If (VERBOSE = 1)
	{
		dm = -v %dm%
		fi = -v %fi%
	}
return

AVER:
	Gui, Submit, NoHide
	If NEW = 1
		apkver = 2.0.0b9
	If OLD = 1
		apkver = 1.5.2
return

~Enter::
~Space::
	GuiControlGet, fCtrl, Focus
	GuiControlGet, fCtrl, HWND, %fCtrl%
	If (fCtrl != hEdit)
		return
	Gui, Submit, NoHide
return

TAB:
	Gui, Submit, NoHide
return
