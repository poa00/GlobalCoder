
#SingleInstance, force
#Persistent
#InstallMouseHook
#installKeybdHook
#KeyHistory, 500
;remap levels/mechanisms

/*
Window: D:\globalcoder\1_globalcoder_numpad.ahk - AutoHotkey v1.1.34.04
Keybd hook: yes
Mouse hook: yes
Enabled Timers: 0 of 0 ()
Interrupted threads: 0
Paused threads: 0 of 0 (0 layers)
Modifiers (GetKeyState() now) = 
Modifiers (Hook's Logical) = 
Modifiers (Hook's Physical) = 
Prefix key is down: no

NOTE: To disable the key history shown below, 
add the line "#KeyHistory 0" anywhere in the script.  
The same method can be used to change the size of the history buffer. 
For example: #KeyHistory 100  (Default is 40, Max is 500)

vk virtual key
sc scan code

types:
h hook
s suppressed (blocked)
i ignored ( because generated by an ahk script)
a artificial
# disabled via #ifwinactive/exist
u unicode character (sendinput)
*/

 ;RCTRL remapped via windows powertools/toys sends:
 ;: Rctrl A3 11D type: n/a
 ;: f24 87 076 type:a 



;Consider this
;- most if not all text editors already have this functionality
;- implimenting it without autohotkey is braindead simple as is
;- why take the trouble

;by implimenting an interface (AHK) between yourself and (ANY) of your
;usual [computer] related task (and some physical), you are given yourself
;a hook into, ultimately, YOUR DATA, YOUR STATS, in real time.

;if I impliment an insert snippet functionality for c# code irrespective of 
;whatever editor im in; ultimately:

;I can say: I used this feature x number of times in 1 month, compared to my
;colleague who microsoft doc lookups the equivalent in a (timed by yourself)
;y number of seconds... saving, for ex, ( manhourwage/3600 ) * N times used * Y saved seconds
;x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=[]=x=x=x=x=x=x=x=x=x=x=x=x=xx=x=x=x=x=x=x=x=[]x=[]


/*
reg: The hotkey is implemented via the operating system's RegisterHotkey() function.
reg(no): Same as above except that this hotkey is inactive (due to being unsupported, disabled, or suspended).
k-hook: The hotkey is implemented via the keyboard hook.
m-hook: The hotkey is implemented via the mouse hook.
2-hooks: The hotkey requires both the hooks mentioned above.
joypoll: The hotkey is implemented by polling the joystick at regular intervals.
*/


/*
CapsLock:: ;caplock toggle on and off to set hotkeys
   KeyWait, CapsLock
    If (A_PriorKey="CapsLock")
        SetCapsLockState, % GetKeyState("CapsLock","T") ? "Off" : "On"
Return

#If, GetKeyState("CapsLock", "T") ;Your CapsLock hotkeys go below



w::Up
a::Left
s::Down
d::Right
q::Send % (A_PriorHotKey = A_ThisHotkey && A_TimeSincePriorHotkey < 200) ? "{Blind}^{Home}" : "{Blind}{PGUP}"
e::Send % (A_PriorHotKey = A_ThisHotkey && A_TimeSincePriorHotkey < 200) ? "{Blind}^{End}" : "{Blind}{PGDN}"

CapsLock Up::
    CapState = 0
    CapText = caps
return

^CapsLock::
    CapState = 1
    CapText = ctrl + caps
return

+CapsLock::
    CapState = 2
    CapText = shift + caps
return

!CapsLock::
    CapState = 3
    CapText = alt + caps
return

#CapsLock::
    CapState = 4
    CapText = win + caps
return

^+CapsLock::
    CapState = 5
    CapText = ctrl + shift + caps
return

^!CapsLock::
    CapState = 6
    CapText = ctrl + alt + caps
return

^#CapsLock::
    CapState = 7
    CapText = ctrl + win + caps
return
;   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
CapsLock & 0::
if Capstate = 1
    tooltip %CapText% + 0
else if Capstate = 2
    tooltip %CapText% + 0
else 
    tooltip caps + 0
return
*/


CapsLock::
   KeyWait, CapsLock                      ; wait for Capslock to be released
   KeyWait, CapsLock, D T0.2              ; and pressed again within 0.2 seconds
   if ErrorLevel
      return
   else if (A_PriorKey = "CapsLock")
      SetCapsLockState, % keyresult := GetKeyState("CapsLock","T") ? "Off" : "On"
      msgbox, % "toggle" keyresult
   return
*CapsLock:: return                        ; This forces capslock into a modifying key.

#If, GetKeyState("CapsLock", "P") ;Your CapsLock hotkeys go below
+Esc::      Run %A_ScriptDir%
+a:: msgbox, 3 keys 
a::run notepad
F1::        ListVars
l::listHotkeys
f24::edit
#If






/*
CapsLock::
KeyWait, %ThisHotkey%, T0.3 ; wait max. 0.3 seconds for the key to be released
    If (ErrorLevel) ; if the command timed out (long press, the key is still pressed after 0.3 seconds)
        SendInput, +%ThisHotkey% ; "shift" it
    else
        SendInput, %ThisHotkey%
    KeyWait, %ThisHotkey% ; don't repeat the action before the key is released

;ListHotkeys, 
;ListLines, on
return 
*/
/*#If, GetKeyState("CapsLock", "P")
a::run notepad.exe ; this will execute notepad application by pressing capslock + a
l::ListHotkeys
t::
    ThisHotkey := StrReplace(A_ThisHotkey, "$") ; remove the $ prefix 

KeyWait, %ThisHotkey%, T0.3 ; wait max. 0.3 seconds for the key to be released
    If (ErrorLevel) ; if the command timed out (long press, the key is still pressed after 0.3 seconds)
        SendInput, +%ThisHotkey% ; "shift" it
    else
        SendInput, %ThisHotkey%
    KeyWait, %ThisHotkey% ; don't repeat the action before the key is released

Return
*/


;InStr(Haystack, Needle [, CaseSensitive?, StartingPos])
;light off = globalcoder remap (code-mode)


>#::f17
>^::
MsgBox, % "pressed : f17"
return 
~f17::
MsgBox, % "pressed : f17"
return

KEYS := ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","1","2","3","4","5","6","7","8","9","0"]

NUMPADKEYS := ["{Numpad0}"]
for k,v in NUMPADKEYS
    hotkey, $%ThisHotkey%,  
    ;Hotkey, KeyName [, Label, Options]
;   #Hotstring, NewOptions
NUMPADKEYS.keynames 



;light on = activate number mode
; create an array/object of the keys you want shift:

; create a hotkey once for each key in this object, using a For-Loop:
For each, key in KEYS
    Hotkey, $%key%, Shift_Key ; the $ prefix forces the keyboard hook to be used
return

Shift_Key:
    ThisHotkey := StrReplace(A_ThisHotkey, "$") ; remove the $ prefix 
    KeyWait, %ThisHotkey%, T0.3 ; wait max. 0.3 seconds for the key to be released
    If (ErrorLevel) ; if the command timed out (long press, the key is still pressed after 0.3 seconds)
        SendInput, +%ThisHotkey% ; "shift" it
    else
        SendInput, %ThisHotkey%
    KeyWait, %ThisHotkey% ; don't repeat the action before the key is released
return









*NumpadAdd::
MouseClick, left,,, 1, 0, D  ; Hold down the left mouse button.
Loop
{
    Sleep, 10
    if !GetKeyState("NumpadAdd", "P")  ; The key has been released, so break out of the loop.
        break
    ; ... insert here any other actions you want repeated.
    MouseClick, left,,, 3, 0, U  ; Release the mouse button.
    send, ^c
    send, {end}{enter}^v
    

}
;MouseClick, WhichButton [, X, Y, ClickCount, Speed, D|U, R]

MsgBox, % "0: `n 3clicked" clipboard
return