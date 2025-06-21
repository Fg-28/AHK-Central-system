#NoEnv
#Persistent
#SingleInstance Force
SetBatchLines, -1
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
CoordMode, ToolTip, Screen
SetMouseDelay, 20
SetKeyDelay, 50, 50
Sleep, 5000
F1::

Loop
{
    ; === YOUR WORKFLOW BEGINS HERE ===
    MouseClick, Left, 309, 284
    Send, ^c
    Sleep, 350
    ClipWait
    copiedText := Trim(Clipboard)
    StringLower, copiedText, copiedText
    if (copiedText != "fin-0001" && copiedText != "fin-0005") {
        Sleep, 7000
        continue
    }

    ; Receipt block
    MouseClick, Left, 1095, 237
    Sleep, 250
    Send, {Down}
    Sleep, 150
    Send, {Tab}
    Sleep, 150
    Send, !{Tab}
    Sleep, 350
    Send, ^c
    Sleep, 200
    ClipWait
    text1 := Clipboard

    Send, {Tab}
    Sleep, 150
    Send, !{Tab}
    Sleep, 350
    Send, ^v
    Sleep, 200
    Send, {Enter}
    Sleep, 150

    MouseClick, Left, 1050, 260
    Sleep, 250
    MouseClick, Left, 1050, 260, 2
    Sleep, 150
    Send, ^c
    Sleep, 150
    ClipWait
    text2 := Clipboard

    Split1 := StrSplit(text1, "/")
    Split2 := StrSplit(text2, "/")
    if (Split1.Length() < 3 || Split2.Length() < 3)
        continue

    Recipt_Amount := Split1[3] * 1
    NewValue := Split2[3] * 1
    if (NewValue != Recipt_Amount)
        ExitApp

    MouseClick, Left, 506, 260
    Sleep, 250

    ; Invoice block
    MouseClick, Left, 1095, 730
    Sleep, 250
    Send, {Down}
    Sleep, 150
    Send, {Tab}
    Sleep, 150
    Send, !{Tab}
    Sleep, 350
    Send, ^c
    Sleep, 200
    ClipWait
    text3 := Clipboard
    Send, {Down}
    Sleep, 150
    Send, {Left}
    Sleep, 150
    Send, !{Tab}
    Sleep, 350
    Send, ^v
    Sleep, 200
    Send, {Enter}
    Sleep, 150

    MouseClick, Left, 1050, 754
    Sleep, 250
    MouseClick, Left, 1050, 754, 2
    Sleep, 150
    Send, ^c
    Sleep, 200
    ClipWait
    text4 := Clipboard

    Split3 := StrSplit(text3, "/")
    Split4 := StrSplit(text4, "/")
    if (Split3.Length() < 3 || Split4.Length() < 3)
        continue

    Recipt_Amount := Split3[3] * 1
    NewValue := Split4[3] * 1
    if (NewValue != Recipt_Amount)
        ExitApp

    MouseClick, Left, 506, 754
    Sleep, 250

    ; Amount compare
    MouseClick, Left, 1420, 260
    Sleep, 250
    MouseClick, Left, 1420, 260
    Sleep, 250
    Send, ^c
    Sleep, 200
    ClipWait
    value5 := Clipboard * 1

    MouseClick, Left, 1420, 754
    Sleep, 250
    MouseClick, Left, 1420, 754
    Sleep, 250
    Send, ^c
    Sleep, 200
    ClipWait
    value6 := Clipboard * 1

    if (value5 = value6) {
        Send, ^s
        Sleep, 18000
        MouseClick, Left, 100, 600
        Sleep, 20000
        MouseClick, Left, 1160, 300
        Sleep, 150
        MouseClick, Left, 100, 600
        Sleep, 1000
        MouseClick, Left, 100, 600
        Sleep, 1000
        MouseClick, Left, 1790, 700, 2
        Send, ^c
        Sleep, 200
        ClipWait
        Total := Clipboard
        if (Total < 3)
            ExitApp
    } else {
        MouseClick, Left, 506, 754
        Sleep, 250
        MouseClick, Left, 506, 260
        Sleep, 250
        ExitApp
    }
}
return

Esc::ExitApp
`::Pause
