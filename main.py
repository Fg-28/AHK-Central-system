# main.py
from flask import Flask, request, Response

app = Flask(__name__)

@app.route("/get_script")
def get_script():
    return Response("""
F1::
MsgBox, Hello from Railway!
Return
""", mimetype="text/plain")

@app.route("/")
def home():
    return "AHK Script Server Running"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
