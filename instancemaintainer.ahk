serverstart=%1%
file=%2%

CoordMode, Pixel, Client

Loop 
{
	Sleep 500 
	PixelGetColor, l_OutputColor, 32, 202, Alt
	MsgBox, %l_OutputColor% is alt
	PixelGetColor, l_OutputColor, 32, 202, Slow
	MsgBox, %l_OutputColor% is slow
}
Until (%l_OutputColor%==0x79808F)

MsgBox, Kill the window!

titlename = [%file%]

WinKill %titlename%