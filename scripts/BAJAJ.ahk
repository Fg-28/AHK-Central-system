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

    StringLower, copiedText, copiedText
    if (copiedText != "fin-0001" && copiedText != "fin-0005") {
        Sleep, 7000
        continue
    }

    ; ... (your logic for receipts, invoice, amounts remains unchanged)

    ; === RUNTIME CHECK every 10 loops (ONLY "START") ===
    if (Mod(loopCount, 3) = 0) {
        baseURL := "https://script.google.com/macros/s/AKfycby_QpaF75QTHhXWxpNPmjsnylyM_8RBDGIbHT3-FygJPGLs1kikJDEkufHHe18kJ1o7vg/exec"
        HttpObj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        HttpObj.Open("GET", baseURL . "?control=BAJAJ&nocache=" . A_TickCount, false)
        HttpObj.Send()
        response := HttpObj.ResponseText

        runStatus := ""
        if RegExMatch(response, """run"":\s*""([^""]+)""", matchRun)
            runStatus := matchRun1

        StringUpper, runStatus, runStatus

        if (runStatus != "START") {
            MsgBox, 48, Script Stopped, Script says %runStatus% — exiting script.
            ExitApp
        }
    }
}
return

Esc::ExitApp
`::Pause
