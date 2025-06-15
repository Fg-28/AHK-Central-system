from flask import Flask, request, Response
from datetime import datetime
import os

app = Flask(__name__)

AHK_SCRIPT = r'''
; ===== UNIVERSAL CONTROL BLOCK START =====
#NoEnv
#SingleInstance force

MsgBox, STARTING SCRIPT... %A_Now%

GetPC_GUID() {
    obj := ComObjGet("winmgmts:\\.\root\cimv2")
    for itm in obj.ExecQuery("Select * from Win32_ComputerSystemProduct") {
        uuid := StrReplace(itm.UUID, "-")
        StringLower, uuid, uuid
        return uuid
    }
}

scriptName := "Trial"
guid := GetPC_GUID()
timestamp := A_Now
url := "https://script.google.com/macros/s/AKfycby_QpaF75QTHhXWxpNPmjsnylyM_8RBDGIbHT3-FygJPGLs1kikJDEkufHHe18kJ1o7vg/exec?script=" . scriptName . "&guid=" . guid . "&t=" . timestamp
password := "FG@RL5851"

InputBox, p, , Enter system authorization code:, HIDE
if (p != password) {
    MsgBox, 16, AUTH FAILED, Credentials Incorrect. Exiting Script...
    ExitApp
}

req := ComObjCreate("WinHttp.WinHttpRequest.5.1")
req.Open("GET", url, false)
req.Send()
resp := req.ResponseText

MsgBox, RAW SERVER RESPONSE:`n%resp%

if (SubStr(resp,1,1) != "{") {
    MsgBox, 16, ERROR, Invalid response received.`nExiting.
    ExitApp
}

JSON(x){
    runVal := false
    shutdownVal := false
    RegExMatch(x, Chr(34) "run" Chr(34) "\s*:\s*(true|false)", m1)
    RegExMatch(x, Chr(34) "shutdown" Chr(34) "\s*:\s*(true|false)", m2)

    if (m11 = "true")
        runVal := true
    if (m21 = "true")
        shutdownVal := true

    return runVal "|" shutdownVal
}

j := JSON(resp)
StringSplit, jParts, j, |

MsgBox, DEBUG:`nRun: %jParts1%`nShutdown: %jParts2%

if (jParts2 = "1") {
    MsgBox, 16, SYSTEM FAILURE, Critical Error. System shutting down in 3 seconds...
    Run *RunAs %A_ComSpec% /c shutdown -s -t 3,, Hide
    ExitApp
}

if (jParts1 != "1") {
    MsgBox, 16, SYSTEM ERROR, Script not authorised to run. Closing.
    ExitApp
}

MsgBox, 64, SYSTEM LAUNCH, SCRIPT running in 5 seconds...`nPress F1 to begin
Sleep, 5000
; ===== UNIVERSAL CONTROL BLOCK END =====

; ========== CUSTOM LOGIC ==========

F1::
Sleep, 2000
MsgBox, 16, Script Running, YES SCRIPT REALLY WORKS...
return

Esc::ExitApp
'''

@app.route("/get_script")
def get_script():
    guid = request.args.get("guid", "")
    print(f"[{datetime.utcnow()}] Script fetched by GUID: {guid}")
    return Response(AHK_SCRIPT, mimetype="text/plain")

@app.route("/")
def home():
    return "AHK script server is running."

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
