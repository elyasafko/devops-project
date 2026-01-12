import socket
from datetime import datetime, timezone

from flask import Flask, jsonify

app = Flask(__name__)

APP_VERSION = "1.2"


@app.route("/")
def hello():
    return "Hello World! you can also check /health, /version, /info endpoints.", 200


@app.route("/health")
def health():
    return "OK", 200


@app.route("/version")
def version():
    return APP_VERSION, 200


@app.route("/info")
def info():
    data = {
        "hostname": socket.gethostname(),
        "server_time_utc": datetime.now(timezone.utc).isoformat(),
        "server_time_local": datetime.now().astimezone().isoformat(),
        "app": "sample-flask-app",
    }
    return jsonify(data), 200


if __name__ == "__main__":
    # app.run(host='0.0.0.0', port=5000, ssl_context='adhoc') # for HTTPS
    app.run(host="0.0.0.0", port=5000) # nosec
