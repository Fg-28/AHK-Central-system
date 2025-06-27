#NoEnv
#Persistent
#SingleInstance Force
SetBatchLines, -1

; === PREVENT MULTIPLE INSTANCES ===
scriptName := "VDP_TAG"
guid := GetPC_GUID()
mutexName := "AHK_" . scriptName . "_" . guid
if !CreateMutex(mutexName) {
    MsgBox, 16, SCRIPT ALREADY RUNNING, This script is already running. Exiting...
    ExitApp
}
CreateMutex(name) {
    static OBJ := {}
    OBJ[name] := DllCall("CreateMutex", "ptr", 0, "int", 0, "str", name)
    return !ErrorLevel && DllCall("GetLastError") != 183
}

; -------------------------------------------------
;  Global delay (in milliseconds) after every Sleep
; -------------------------------------------------
globalDelay := 100

; Wrapper for all Sleep calls
MySleep(ms) {
    Sleep, ms
    if (globalDelay > 0)
        Sleep, globalDelay
}

CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
CoordMode, ToolTip, Screen
SetMouseDelay, 25
SetKeyDelay, 25, 25
MySleep(5000)

F1::

Loop
{
    ; === YOUR WORKFLOW BEGINS HERE ===
    MouseClick, Left, 309, 284
    Send, ^c
    MySleep(350)
    ClipWait
    copiedText := Trim(Clipboard)
    StringLower, copiedText, copiedText
    if (copiedText != "fin-0001" && copiedText != "fin-0005") {
        MySleep(7000)
        continue
    }

    ; Receipt block
    MouseClick, Left, 1095, 237
    MySleep(250)
    Send, {Down}
    MySleep(150)
    Send, {Tab}
    MySleep(500)
    Send, !{Tab}
    MySleep(500)
    Send, ^c
    MySleep(200)
    ClipWait
    text1 := Clipboard

    Send, {Tab}
    MySleep(250)
    Send, ^c
    MySleep(200)
    ClipWait
    text3 := Clipboard
    MySleep(200)
    Send, {Down}
    MySleep(250)
    Send, {Left}
    MySleep(500)
    Send, !{Tab}
    MySleep(500)
    Send, %text1%
    MySleep(200)
    Send, {Enter}
    MySleep(150)

    MouseClick, Left, 1050, 260
    MySleep(250)
    MouseClick, Left, 1050, 260, 2
    MySleep(150)
    Send, ^c
    MySleep(150)
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

    MouseClick, Left, 505, 260
    MySleep(250)

    ; Invoice block
    MouseClick, Left, 1095, 730
    MySleep(250)
    Send, {Down}
    MySleep(150)
    Send, {Tab}
    MySleep(150)
    Send, %text3%
    MySleep(250)
    Send, {Enter}
    MySleep(150)
    MouseClick, Left, 1050, 754
    MySleep(250)
    MouseClick, Left, 1050, 754, 2
    MySleep(150)
    Send, ^c
    MySleep(200)
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

    MouseClick, Left, 504, 752
    MySleep(250)

    ; Amount compare
    MouseClick, Left, 1420, 260
    MySleep(250)
    MouseClick, Left, 1420, 260
    MySleep(250)
    Send, ^c
    MySleep(200)
    ClipWait
    value5 := Clipboard * 1

    MouseClick, Left, 1420, 754
    MySleep(250)
    MouseClick, Left, 1420, 754
    MySleep(250)
    Send, ^c
    MySleep(200)
    ClipWait
    value6 := Clipboard * 1

    if (value5 = value6) {
        Send, ^s
        MySleep(18000)
        MouseClick, Left, 100, 600
        MySleep(20000)
        MouseClick, Left, 1160, 300
        MySleep(150)
        MouseClick, Left, 100, 600
        MySleep(1000)
        MouseClick, Left, 100, 600
        MySleep(1000)
        MouseClick, Left, 1790, 700, 2
        Send, ^c
        MySleep(200)
        ClipWait
        Total := Clipboard
        if (Total < 3)
            ExitApp
    } else {
        MouseClick, Left, 506, 754
        MySleep(250)
        MouseClick, Left, 506, 260
        MySleep(250)
        ExitApp
    }
    text1 := ""
    text2 := ""
    text3 := ""
    text4 := ""
    Clipboard := ""
    MySleep(300)
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
