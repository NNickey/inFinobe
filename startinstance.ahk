#SingleInstance Ignore
serverstart=%1%
file=%2%
path=C:\Users\nicen\Documents\finobehandler\
studiopath=F:\Finobe\2012\RobloxApp.exe

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

titlename = Finobe - [%file%]


WinWait Roblox
 ;ClassNN:	msctls_statusbar321 'ready'!
 ;Text:	Ready
 
 ;command bar ClassNN:	RichEdit20A1
 
 
;loop{
;	sleep, 200
;	ControlGet, a, Hwnd, , Button1, Roblox
;	ControlGetText, istext, msctls_statusbar321, %titlename%
;} until (%istext%==Ready) or (errorlevel=0)
;ControlClick, Button1, Roblox

WinWait %titlename%

istext=no
loop {
	sleep, 200
	ControlGetText, istext, msctls_statusbar321, %titlename%
} until (%istext%==Ready)

Sleep, 3200

WinActivate, %titlename%
ControlFocus, RichEdit20A1, %titlename%
ControlSetText, RichEdit20A1, _G.file="%file%", %titlename%
Sleep, 100
Send, {Enter}

Sleep, 400

WinActivate, %titlename%
ControlFocus, RichEdit20A1, %titlename%
ControlSetText, RichEdit20A1, dofile("http://www.nickoakzhost.nigga/serverstart.lua?v103"), %titlename%
Sleep, 100
Send, {Enter}

Sleep, 400

WinActivate, %titlename%
ControlFocus, RichEdit20A1, %titlename%
 ;MsgBox, "Ready to send..."
 ;MsgBox, %serverstart%
ControlSetText, RichEdit20A1, %serverstart%, %titlename%
 ;pSendChars(serverstart,"RichEdit20A1",titlename)
 Sleep, 100
Send, {Enter}