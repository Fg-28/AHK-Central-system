#NoEnv
#Persistent
#SingleInstance Force
SetBatchLines, -1
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
CoordMode, ToolTip, Screen
SetMouseDelay, 10
SetKeyDelay, 50, 50
Sleep, 5000

MainLoop:
F1::
Loop
{

    MouseClick, Left, 309, 284
    Send, ^c
    Sleep, 350
    ClipWait
    VDP := Trim(Clipboard)
    if (VDP != "VDP" && VDP != "vdp" && VDP != "Vdp")
    {
        Sleep, 7000  ; Wait for 7 seconds
        continue 
    }

    MouseClick, Left, 505, 260
    Sleep, 350
    MouseClick, Left, 543, 238
    Sleep, 350
    Send, {Enter}
    Sleep, 350

; Copy the invoice number from Google Sheet

    Send, !{Tab}
    Sleep, 150
    Send, ^c
CopiedData := Clipboard

; Extract 3rd and 4th characters (AutoHotkey strings are 1-indexed)
char3 := SubStr(CopiedData, 3, 1)
char4 := SubStr(CopiedData, 4, 1)

if ( char3 = "" || char4 = "")
{
    MsgBox, 16, Error, Invalid data! Invoice is blank.
    ExitApp
}


; pasting data into invoice in Party Recon.

    Send, !{Tab}
    Sleep, 300
    MouseClick, Left, 1093, 729
    Sleep, 200
    Send, {Down}
    Sleep, 150
    Send, {Tab}
    Send, ^v
    Send, {Enter}
    Sleep, 350
    Clipboard := ""

    MouseClick, Left, 505, 755
    Sleep, 150
    MouseClick, Left, 1551, 755
    Sleep, 200
    MouseClick, Left, 1551, 755, 2
    Sleep, 150
    Send, ^c
    Sleep, 150
    ClipWait
    Amount := Clipboard
    if (Amount == "0")
    {
        Send, !{Tab}
        Sleep, 150
        Send, {Down}
        Sleep, 250
        Send, ^c
	Sleep, 150
        Send, !{Tab}
	Sleep, 150
        MouseClick, Left, 1093, 729
	Sleep, 350
        Send, {Tab}
        Send, {Tab}
        Send, {Down}
        Send, {Tab}
        Send, {Down}
        Send, {Tab}
        Send, ^v
        Sleep, 150
        Send, {Enter}
        Sleep, 150
        MouseClick, Left, 505, 780
        Sleep, 150
        MouseClick, Left, 1551, 780
        Sleep, 150
        MouseClick, Left, 1551, 780, 2
        Send, ^c
        Sleep, 150
        ClipWait
        Second:= Clipboard
        if (Second == "0")
        {
            Send, !{Tab}
            Sleep, 150
            Send, {Down}
            Sleep, 150
	    Send, !{Tab}
	    Sleep, 150
        }
    }
    Send, ^s
    Sleep, 18000
    MouseClick, Left, 100, 600
    Sleep, 24000
    MouseClick, Left, 1160, 300
    Sleep, 150
    MouseClick, Left, 100, 600
    Sleep, 1000
    MouseClick, Left, 100, 600
    Sleep, 1000
    MouseClick, Left, 1791, 700, 2	
    Send, ^c
    Sleep, 150
    ClipWait
    Total := Clipboard 
    if (Total < 3)
    {
        ExitApp
        break
    }
}
Esc::ExitApp
`::Pause
