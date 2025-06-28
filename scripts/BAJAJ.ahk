#NoEnv
#Persistent
#SingleInstance Force
SetBatchLines, -1

CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
CoordMode, ToolTip, Screen

SetMouseDelay, 22
SetKeyDelay, 22, 22

Sleep, 5000

F1::

Loop
{
    ; === YOUR WORKFLOW BEGINS HERE ===
    MouseClick, Left, 308, 283
    Send, ^c
    Sleep, 350
    Sleep, 100
    ClipWait
    copiedText := Trim(Clipboard)
    StringLower, copiedText, copiedText
    if (copiedText != "fin-0001" && copiedText != "fin-0005") {
        Sleep, 7000
        Sleep, 100
        continue
    }

    ; Receipt block
    MouseClick, Left, 1094, 236
    Sleep, 250
    Sleep, 100
    Send, {Down}
    Sleep, 150
    Sleep, 100
    Send, {Tab}
    Sleep, 500
    Sleep, 100
    Send, !{Tab}
    Sleep, 500
    Sleep, 100
    Send, ^c
    Sleep, 200
    Sleep, 100
    ClipWait
    text1 := Clipboard

    Send, {Tab}
    Sleep, 250
    Sleep, 100
    Send, ^c
    Sleep, 200
    Sleep, 100
    ClipWait
    text3 := Clipboard
    Sleep, 200
    Sleep, 100
    Send, {Down}
    Sleep, 250
    Sleep, 100
    Send, {Left}
    Sleep, 500
    Sleep, 100
    Send, !{Tab}
    Sleep, 500
    Sleep, 100
    Send, %text1%
    Sleep, 200
    Sleep, 100
    Send, {Enter}
    Sleep, 150
    Sleep, 100

    MouseClick, Left, 1049, 259
    Sleep, 250
    Sleep, 100
    MouseClick, Left, 1049, 259, 2
    Sleep, 150
    Sleep, 100
    Send, ^c
    Sleep, 150
    Sleep, 100
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

    MouseClick, Left, 504, 259
    Sleep, 250
    Sleep, 100

    ; Invoice block
    MouseClick, Left, 1094, 729
    Sleep, 250
    Sleep, 100
    Send, {Down}
    Sleep, 150
    Sleep, 100
    Send, {Tab}
    Sleep, 150
    Sleep, 100
    Send, %text3%
    Sleep, 250
    Sleep, 100
    Send, {Enter}
    Sleep, 150
    Sleep, 100
    MouseClick, Left, 1049, 753
    Sleep, 250
    Sleep, 100
    MouseClick, Left, 1049, 753, 2
    Sleep, 150
    Sleep, 100
    Send, ^c
    Sleep, 200
    Sleep, 100
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

    MouseClick, Left, 503, 751
    Sleep, 250
    Sleep, 100

    ; Amount compare
    MouseClick, Left, 1419, 259
    Sleep, 250
    Sleep, 100
    MouseClick, Left, 1419, 259
    Sleep, 250
    Sleep, 100
    Send, ^c
    Sleep, 200
    Sleep, 100
    ClipWait
    value5 := Clipboard * 1

    MouseClick, Left, 1419, 753
    Sleep, 250
    Sleep, 100
    MouseClick, Left, 1419, 753
    Sleep, 250
    Sleep, 100
    Send, ^c
    Sleep, 200
    Sleep, 100
    ClipWait
    value6 := Clipboard * 1

    if (value5 = value6) {
        Send, ^s
        Sleep, 18000
        Sleep, 100
        MouseClick, Left, 99, 599
        Sleep, 20000
        Sleep, 100
        MouseClick, Left, 1159, 299
        Sleep, 150
        Sleep, 100
        MouseClick, Left, 99, 599
        Sleep, 1000
        Sleep, 100
        MouseClick, Left, 99, 599
        Sleep, 1000
        Sleep, 100
        MouseClick, Left, 1789, 699, 2
        Send, ^c
        Sleep, 200
        Sleep, 100
        ClipWait
        Total := Clipboard
        if (Total < 3)
            ExitApp
    } else {
        MouseClick, Left, 505, 753
        Sleep, 250
        Sleep, 100
        MouseClick, Left, 505, 259
        Sleep, 250
        Sleep, 100
        ExitApp
    }

    text1 := ""
    text2 := ""
    text3 := ""
    text4 := ""
    Clipboard := ""
    Sleep, 300
    Sleep, 100
}
return

~Esc::
    SetTimer, CleanupTemp, -100
return

CleanupTemp:
    FolderPath := A_Temp "\.ahk_hidden"
    FileRemoveDir, %FolderPath%, 1
    ExitApp
return

`::Pause
