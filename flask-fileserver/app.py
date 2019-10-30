from flask import Flask, request, render_template, send_from_directory, session, url_for, redirect, jsonify
from flask_cors import CORS, cross_origin
import dbHandler as dbHandler

app = Flask(__name__)
CORS(app, support_credentials=True)

@app.route("/addUUID/<uuid>")
@cross_origin(supports_credentials=True)
def adduuid(uuid):
    f = open("uuids.txt", "at")
    f.write(uuid + "\n")
    f.close()
    return "UUID {} added to the list".format(uuid) 

@app.route("/getUUID/<uuid>")
@cross_origin()
def getuuid(uuid):
    f = open("uuids.txt", "rt")
    line = f.readline().strip()
    while line != "":
        if(line == uuid):
            return jsonify(True)
        line = f.readline().strip()
    else:
        return jsonify(False)

@app.route("/getAllUUIDs/")
@cross_origin()
def getall():
    f = open("uuids.txt", "rt")
    lines = f.readlines()
    lines = tuple(line.strip() for line in lines)
    return ",".join(lines)

@app.route("/")
def index():
    return render_template("mainpage.html")

@app.route("/1")
def index1():
    return render_template("mainpage1.html")

# @app.route("/login")
# def login():
#     return render_template("login.html")

@app.route('/login', methods=['POST', 'GET'])
def login():
    if request.method=='POST':
        username = request.form['username']
        password1 = request.form['password']
        # dbHandler.insertUser(username, password1,email)	
        login = dbHandler.checkLogin(username, password1)
        if(login):
            return redirect(url_for("index1"))
        else:
            return render_template("login.html")
    else:
        return render_template("login.html")

# @app.route("/signup")
# def signup():
#     return render_template("signup.html")

@app.route('/signup', methods=['POST', 'GET'])
def signup():
	if request.method=='POST':
		username = request.form['username']
		password1 = request.form['password']
		email =request.form['email']
		dbHandler.insertUser(username, password1,email)	
		return redirect(url_for("login"))
	else:
		return render_template('signup.html')

@app.route('/static/<path:path>')
def serve_static(path):
    return send_from_directory('static/' + path)

if __name__ == "__main__":
    app.run()