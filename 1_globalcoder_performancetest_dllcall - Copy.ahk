﻿DllCall("QueryPerformanceFrequency", "Int64*", &freq := 0)
DllCall("QueryPerformanceCounter", "Int64*", &CounterBefore := 0)
Sleep 10000
DllCall("QueryPerformanceCounter", "Int64*", &CounterAfter := 0)
MsgBox "Elapsed QPC time is " . (CounterAfter - CounterBefore) / freq * 1000 " ms"