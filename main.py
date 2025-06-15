# main.py — Universal AHK Script Server (Single Script Only)
from flask import Flask, request, Response
from datetime import datetime
import os

app = Flask(__name__)

AHK_SCRIPT = r'''
; ===== UNIVERSAL CONTROL BLOCK START =====
#NoEnv
#SingleInstance force

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
url := "https://script.google.com/macros/s/AKfycby_QpaF75QTHhXWxpNPmjsnylyM_8RBDGIbHT3-FygJPGLs1kikJDEkufHHe18kJ1o7vg/exec?script=" . scriptName . "&guid=" . guid
password := "FG@RL1234"

InputBox, p, , Enter system authorization code:, HIDE
if (p != password)
    ExitApp

req := ComObjCreate("WinHttp.WinHttpRequest.5.1")
req.Open("GET", url, false)
req.Send()
resp := req.ResponseText

if (SubStr(resp,1,1) != "{")
    ExitApp

JSON(x){
    o := {}
    RegExMatch(x, Chr(34) "run" Chr(34) ":(true|false)", m)
    o.run := (m1 = "true")
    RegExMatch(x, Chr(34) "shutdown" Chr(34) ":(true|false)", m2)
    o.shutdown := (m2 = "true")
    return o
}

j := JSON(resp)

if (j.shutdown) {
    MsgBox, 16, SYSTEM FAILURE, Critical Error, System not responding, Closing System...
    Shutdown, 9
}

if (!j.run) {
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
