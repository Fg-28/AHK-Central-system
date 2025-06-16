; ======= AHK SCRIPT: BAJAJ.ahk =======

; Initial Prompt
InputBox, userInput, Password Required, Please enter the password:, HIDE
if (userInput != "FG@RL1234") {
    MsgBox, Incorrect password. Exiting...
    ExitApp
}

; Initialize GUID
RegRead, guid, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Cryptography, MachineGuid
if (guid = "") {
    MsgBox, Could not read Machine GUID. Exiting...
    ExitApp
}
guid := StrReplace(guid, "-", "")

; === LOG TO GOOGLE SHEET ===
FormatTime, timestamp, , yyyy-MM-dd HH:mm:ss
logURL := "https://script.google.com/macros/s/AKfycby_QpaF75QTHhXWxpNPmjsnylyM_8RBDGIbHT3-FygJPGLs1kikJDEkufHHe18kJ1o7vg/exec?name=BAJAJ&time=" . timestamp . "&guid=" . guid

logReq := ComObjCreate("WinHttp.WinHttpRequest.5.1")
logReq.Open("GET", logURL, false)
logReq.Send()

; === CHECK START STATUS BEFORE BEGINNING ===
controlURL := "https://script.google.com/macros/s/AKfycby_QpaF75QTHhXWxpNPmjsnylyM_8RBDGIbHT3-FygJPGLs1kikJDEkufHHe18kJ1o7vg/exec?control=BAJAJ&nocache=" . A_TickCount
ctrlReq := ComObjCreate("WinHttp.WinHttpRequest.5.1")
ctrlReq.Open("GET", controlURL, false)
ctrlReq.Send()
response := ctrlReq.ResponseText

if RegExMatch(response, "\"run\"\s*:\s*\"([^\"]+)\"", matchRun)
    runStatus := matchRun1
else
    runStatus := ""

StringUpper, runStatus, runStatus
if (runStatus != "START") {
    MsgBox, 48, Script Not Authorized, Script run status is %runStatus%. Exiting...
    ExitApp
}

; Wait message
MsgBox, 64, SYSTEM LAUNCH, Script will start in 5 seconds...`nPress F1 to begin.
Sleep, 5000

; ========== MAIN LOGIC ==========
F1::
loopCount := 0

Loop
{
    loopCount++

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

    ; Amount compare
    MouseClick, Left, 1420, 260
    Sleep, 250
    MouseClick, Left, 1420, 260
    Sleep, 250
    Send, ^c
    Sleep, 150
    ClipWait
    value5 := Clipboard * 1

    MouseClick, Left, 1420, 754
    Sleep, 250
    MouseClick, Left, 1420, 754
    Sleep, 250
    Send, ^c
    Sleep, 150
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
        MouseClick, Left, 1791, 700, 2
        Send, ^c
        Sleep, 150
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

    ; === RECHECK START every 2 loops ===
    if (Mod(loopCount, 2) = 0) {
        controlURL := "https://script.google.com/macros/s/AKfycby_QpaF75QTHhXWxpNPmjsnylyM_8RBDGIbHT3-FygJPGLs1kikJDEkufHHe18kJ1o7vg/exec?control=BAJAJ&nocache=" . A_TickCount
        HttpObj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        HttpObj.Open("GET", controlURL, false)
        HttpObj.Send()
        response := HttpObj.ResponseText

        runStatus := ""
        if RegExMatch(response, "\"run\"\s*:\s*\"([^\"]+)\"", matchRun)
            runStatus := matchRun1

        StringUpper, runStatus, runStatus
        if (runStatus != "START") {
            MsgBox, 48, Script Stopped, Google Sheet says %runStatus% — exiting script.
            ExitApp
        }
    }
}
return

Esc::ExitApp
`::Pause
