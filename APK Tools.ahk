; ##################################################
; ################### DIRECTIVES ###################
; ##################################################
;@Ahk2Exe-SetName APK Tools
;@Ahk2Exe-SetDescription APK Tools
;@Ahk2Exe-SetVersion 1.0.0-alpha
;@Ahk2Exe-SetCopyright genealyson.torcende@gmail.com
;@Ahk2Exe-SetTrademarks PrivaTech -- GAFT
;@Ahk2Exe-SetOrigFilename APK Tools.ahk
;@Ahk2Exe-SetCompanyName PrivaTech -- GAFT
;@Ahk2Exe-SetMainIcon PrivaTech.ico


; ##################################################
; ##################### CONFIG #####################
; ##################################################
#MaxThreads 20
#NoEnv
#NoTrayIcon
#Persistent
#SingleInstance force

Process, Priority,, High
SendMode Input
SetBatchLines, -1
SetKeyDelay, -1
SetTitleMatchMode, 2
SetTitleMatchMode, Slow
SetTitleMatchMode, RegEx


; ##################################################
; ################### INITIALIZE ###################
; ##################################################
SetWorkingDir %A_ScriptDir%
;@Ahk2Exe-IgnoreBegin
VERSION := "1.0.0.0"
;@Ahk2Exe-IgnoreEnd
/*@Ahk2Exe-Keep
FileGetVersion, VERSION, %A_ScriptFullPath%
*/
TITLE = APK Tools

RegRead, DPI, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, AppliedDPI
If ErrorLevel
	DPI = 96
DPI := DPI / 96
FSize := 2 - DPI + 1
DIR = %A_ScriptDir%

Gui, +Disabled -SysMenu -DPIScale
Gui, Font, % "s" 10/DPI "w" 350*FSize, Verdana
Gui, Add, Text, vText cRed, Please WAIT!
Gui, Font, % "s" 8/DPI
Gui, Add, Text, xp y+10, Initializing APK Tools%A_Space% . %A_Space% . %A_Space% .
Gui, Font
Gui, Add, Progress, x10 y+10 vProgress w200 h15 -Smooth
Gui, Show, Hide
Gui +LastFound
WinGetPos, , , GuiWidth
GuiControlGet, GuiInfo, Pos, Text
GuiControl, Move, Text, % "x" GuiWidth/2 - GuiInfoW/2
Gui, Show, Center, %TITLE% v%VER%

IfNotExist, APK Files
	FileCreateDir, APK Files
IfNotExist, Logs
	FileCreateDir, Logs
IfNotExist, OUTPUT
	FileCreateDir, OUTPUT
IfNotExist, Projects
	FileCreateDir, Projects
IfNotExist, tools
	FileCreateDir, tools
FileCreateDir, %A_Temp%\20110911
FileSetAttrib, +SH, %A_Temp%\20110911, 2
GuiControl,, Progress, +5
FileInstall, 7za.exe, %A_Temp%\20110911\7za.exe
FileInstall, list.txt, %A_Temp%\20110911\list.txt
FileInstall, tools.zip, %A_Temp%\20110911\tools.zip
GuiControl,, Progress, +5
Loop, Read, %A_Temp%\20110911\list.txt
{
	IfNotExist, tools\%A_LoopReadLine%
		RunWait, %A_Temp%\20110911\7za.exe x -otools %A_Temp%\20110911\tools.zip %A_LoopReadLine%,,hide
	GuiControl,, Progress, +5
}
Sleep, 1000
FileDelete, %A_Temp%\20110911\temp.log
FileDelete, %A_Temp%\20110911\7za.exe
FileDelete, %A_Temp%\20110911\list.txt
FileDelete, %A_Temp%\20110911\tools.zip
GuiControl,, Progress, +5
Sleep, 1000
Gui, Destroy


; ##################################################
; ################### VARIABLES ####################
; ##################################################
ACLS_TT := "Select APK Compression Level"
RCLS_TT := "Select .arsc Compression Level"
HS_TT := "Enter max java heap space here"
Link_TT := "genealyson.torcende@gmail.com"
SELECT_TT := "Click here to select current project"
GENK_TT := "Android Market supported Key"
TEST_TT := "General Signature"
PLOC_TT := "Click here to enter APK location"
PNAME_TT := "Click here to enter APK name"
KOWN_TT := "Click here to enter owner name"
KNAME_TT := "Click here to enter keystore name"
KALIAS_TT := "Click here to enter keystore alias"
KPASS_TT := "Click here to enter keystore pass"

FormatTime, LogFile, %A_Now%, MMddyy
LogFile = %DIR%\Logs\%LogFile%.log
TempFile = %A_Temp%\20110911\temp.log
d = 4
dm = d
dms = Sources and Resources
acl = 9
acls = ULTRA
rcl = 0
rcls = NONE
hs = 1024
apkver = 2.0.0b9
fi = if
projpath =
projname =
signkey = GEN
apkloc = /system/app/
apkname =
frampath =
framname =
framtag =
keyown =
keyname =
keyalias =
keypass =


; ##################################################
; ###################### MAIN ######################
; ##################################################
WM_MOUSEMOVE()
{
    static CurrControl, PrevControl, _TT
    CurrControl := A_GuiControl
  If CurrControl contains %A_Space%
    return
    If (CurrControl != PrevControl)
    {
    ToolTip % %CurrControl%_TT
        PrevControl := CurrControl
    }
    return
  RemoveToolTip:
        ToolTip
    SetTimer, RemoveToolTip, Off
    return
}
WM_CHECKINPUT(in)
{
  global
  static CurrControl
  CurrControl := A_GuiControl
  If (CurrControl = "HS")
  {
    If in = 8
      return
    in := Chr(in)
    If in is not digit
      Return, 0
  }
}

GoSub, GUI
IfNotExist, %LogFile%
{
	UpdateLog("********************************************************************************",n,n)
	UpdateLog("`t`t`t" TITLE " by kermage",n,n)
	UpdateLog("********************************************************************************",n,n)
}
UpdateLog("Session Started!")
RunWait, %comspec% /C java -version,,hide
If ErrorLevel
	MsgBox, 262192, %TITLE% v%VER%, JAVA NOT INSTALLED!
RunWait, %comspec% /C "%DIR%\tools\adb.exe" version,,hide
If ErrorLevel
	MsgBox, 262192, %TITLE% v%VER%, ABD NOT FOUND!
OnMessage(0x200, "WM_MOUSEMOVE")
OnMessage(0x102, "WM_CHECKINPUT")


return ; =========== END OF AUTO EXECUTE ===========


; ##################################################
; #################### INCLUDES ####################
; ##################################################
#include func.ahk
#include gui.ahk
