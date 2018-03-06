file=%1%

titlename = Finobe - [%file%]

WinGet, pid, PID, %titlename%
WinKill %titlename%
Process, Close, %pid%

titlename = Finobe Server - [%file%]

WinGet, pid, PID, %titlename%
WinKill %titlename%
Process, Close, %pid%