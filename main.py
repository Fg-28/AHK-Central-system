from flask import Flask, request, Response

app = Flask(__name__)

@app.route("/get_script")
def get_script():
    return Response("F1::`nMsgBox, Hello from Railway!`nReturn", mimetype="text/plain")

@app.route("/")
def home():
    return "AHK Script Server Running"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
