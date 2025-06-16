F1::
loopCount := 0

Loop
{
    loopCount++

    ; === MAIN LOGIC STARTS ===
    MouseClick, Left, 309, 284
    Send, ^c
    Sleep, 350
    ClipWait
    copiedText := Trim(Clipboard)

    ; Case-insensitive check
    StringLower, copiedText, copiedText
    if (copiedText != "fin-0001" && copiedText != "fin-0005") {
        Sleep, 7000
        continue
    }

    ; Process receipt
    MouseClick, Left, 1095, 237
    Sleep, 250
    Send, {Down}
    Sleep, 150
    Send, {Tab}
    Sleep, 150
    Send, !{Tab}
    Sleep, 350
    Send, ^c
    Sleep, 150
    ClipWait
    text1 := Clipboard

    Send, {Tab}
    Sleep, 150
    Send, !{Tab}
    Sleep, 350
    Send, ^v
    Sleep, 150
    Send, {Enter}
    Sleep, 150

    ; Get second value for receipt
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

    ; Select invoice
    MouseClick, Left, 1095, 730
    Sleep, 250
    Send, {Down}
    Sleep, 150
    Send, {Tab}
    Sleep, 150
    Send, !{Tab}
    Sleep, 350
    Send, ^c
    Sleep, 150
    ClipWait
    text3 := Clipboard
    Send, {Down}
    Sleep, 150
    Send, {Left}
    Sleep, 150
    Send, !{Tab}
    Sleep, 350
    Send, ^v
    Sleep, 150
    Send, {Enter}
    Sleep, 150

    ; Get second value for invoice
    MouseClick, Left, 1050, 754
    Sleep, 250
    MouseClick, Left, 1050, 754, 2
    Sleep, 150
    Send, ^c
    Sleep, 150
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

    ; Check Amount Match
    MouseClick, Left, 1420, 260
    Sleep, 250
    MouseClick, Left, 1420, 260    
    Sleep, 250
    Send, ^c
    Sleep, 150
    ClipWait
    text5 := Clipboard

    MouseClick, Left, 1420, 754
    Sleep, 250
    MouseClick, Left, 1420, 754   
    Sleep, 250
    Send, ^c
    Sleep, 150
    ClipWait
    text6 := Clipboard

    value5 := text5 * 1
    value6 := text6 * 1

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
        MouseClick, Left, 1791, 700, 2
        Send, ^c
        Sleep, 150
        ClipWait
        Total := Clipboard
        if (Total < 3) {
            ExitApp
        }
    } else {
        MouseClick, Left, 506, 754
        Sleep, 250
        MouseClick, Left, 506, 260
        Sleep, 250
        ExitApp
    }

    ; === RUNTIME CHECK every 10 loops ===
    if (Mod(loopCount, 10) = 0) {
        baseURL := "https://script.google.com/macros/s/AKfycby_QpaF75QTHhXWxpNPmjsnylyM_8RBDGIbHT3-FygJPGLs1kikJDEkufHHe18kJ1o7vg/exec"
        HttpObj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        HttpObj.Open("GET", baseURL . "?control=BAJAJ&nocache=" . A_TickCount, false)
        HttpObj.Send()
        response := HttpObj.ResponseText

        if RegExMatch(response, """run"":\s*""([^""]+)""", matchRun)
            runStatus := matchRun1
        else
            runStatus := "STOP"

        if RegExMatch(response, """shutdown"":\s*""([^""]+)""", matchShutdown)
            shutdownFlag := matchShutdown1
        else
            shutdownFlag := "YES"

        StringUpper, runStatus, runStatus
        StringUpper, shutdownFlag, shutdownFlag

        if (shutdownFlag != "NO") {
            MsgBox, 16, Shutdown Triggered, Google Sheet says SHUTDOWN.`nShutting down now.
            Shutdown, 1
            ExitApp
        }

        if (runStatus != "START") {
            MsgBox, 48, Script Stopped, Google Sheet says %runStatus% — exiting script.
            ExitApp
        }
    }
}
return

Esc::ExitApp
`::Pause
