#SingleInstance Ignore
serverstart=%1%
file=%2%
path=C:\Users\nicen\Documents\finobehandler\
studiopath=F:\Finobe\2007\RobloxApp.exe

;FileRead, runcode, %path%serverstart.lua
;StringReplace,runcode,runcode,`r`n,%A_Space%,A
;StringReplace,runcode,runcode,putfilehere,%file%,A


pSendChars(string, control := "", WinTitle := "", WinText := "", ExcludeTitle := "", ExcludeText := "")
{
    for k, char in StrSplit(string)
        postmessage, WM_CHAR := 0x102, Asc(char),, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    return
}

Run %studiopath% "%path%%file%"

titlename = Finobe Server - [%file%]


;WinWait Roblox
 ;ClassNN:	msctls_statusbar321 'ready'!
 ;Text:	Ready
 
 ;command bar ClassNN:	RichEdit20A1
 

WinWait %titlename%

istext=no
loop {
	sleep, 200
	ControlGetText, istext, msctls_statusbar321, %titlename%
} until (%istext%==Ready)

Sleep, 2500

istext=no
loop {
	sleep, 200
	ControlGetText, istext, msctls_statusbar321, %titlename%
} until (%istext%==Ready)

WinActivate, %titlename%
ControlFocus, RichEdit20A1, %titlename%
ControlSetText, RichEdit20A1, _G.file="%file%", %titlename%
Send, {Enter}


Sleep, 900

gamestring=loadstring(game:HttpGet('http://www.nickoakzhost.nigga/serverstart.lua?v114',true))()


WinActivate, %titlename%
ControlFocus, RichEdit20A1, %titlename%
ControlSetText, RichEdit20A1, %gamestring%, %titlename%
Send, {Enter}

Sleep, 1100

WinActivate, %titlename%
ControlFocus, RichEdit20A1, %titlename%
 ;MsgBox, "Ready to send..."
 ;MsgBox, %serverstart%
ControlSetText, RichEdit20A1, %serverstart%, %titlename%
 ;pSendChars(serverstart,"RichEdit20A1",titlename)
Send, {Enter}