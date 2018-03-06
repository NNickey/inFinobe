titlename = Finobe

ControlGetText, istext, Static2, Roblox

failed := "Failed to open document."
if (istext==failed) {
	WinActivate, Roblox, OK
	ControlClick,  OK, Roblox
	ControlClick, X175 Y108, Roblox
	MsgBox, CLOSE IT
}