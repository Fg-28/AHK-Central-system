# main.py — Universal AHK Script Server (Single Script Only)
from flask import Flask, request, Response
from datetime import datetime
import os

app = Flask(__name__)

# === Single AHK script you can freely edit below ===
AHK_SCRIPT = r"""
F1::
MsgBox, Hello from Railway!
Return
"""

@app.route("/get_script")
def get_script():
    guid = request.args.get("guid", "")
    print(f"[{datetime.utcnow()}] Script fetched by GUID: {guid}")
    return Response(AHK_SCRIPT, mimetype="text/plain")

@app.route("/")
def home():
    return "AHK Script Server Running"

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))  # ✅ Railway assigns port dynamically
    app.run(host="0.0.0.0", port=port)
