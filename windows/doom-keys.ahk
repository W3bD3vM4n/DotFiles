; DOOM KEYBINDINGS

; Reference Symbols
; '::' = on the left are the keys to press
; ';'  = comment a line (without quotes)
; '#'  = windows key
; '!'  = alt key
; '^'  = ctrl key
; '+'  = shift key


; Map Capslock to Control
; Map press & release of Capslock with no other key to Esc
; Press both shift keys together to toggle Capslock

*Capslock::
    Send {Blind}{LControl down}
    return

*Capslock up::
    Send {Blind}{LControl up}
    ; Tooltip, %A_PRIORKEY%
    ; SetTimer, RemoveTooltip, 1000
    if A_PRIORKEY = CapsLock
    {
        	Send {Esc}
    }
    return

RemoveTooltip(){
    SetTimer, RemoveTooltip, Off
    Tooltip
    return
}

ToggleCaps(){
    ; this is needed because by default, AHK turns CapsLock off before doing Send
    SetStoreCapsLockMode, Off
    Send {CapsLock}
    SetStoreCapsLockMode, On
    return
}
LShift & RShift::ToggleCaps()
RShift & LShift::ToggleCaps()

$Esc::  ; Disable Esc on the keyboard by assigning a non-existing key


; AutoHotkey manage scripts

!p::Pause    ; Pause script with Ctrl+Shift+P
!s::Suspend  ; Suspend script with Ctrl+Alt+S
!r::Reload   ; Reload script with Ctrl+Alt+R