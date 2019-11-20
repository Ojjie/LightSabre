from flask import Flask, request, render_template, send_from_directory, session, url_for, redirect, jsonify, make_response
from flask_cors import CORS, cross_origin
import dbHandler as dbHandler
import sys
import datetime
import dateutil.parser

import json
from web3 import Web3, HTTPProvider
from web3.contract import ConciseContract

app = Flask(__name__)
CORS(app, support_credentials=True)
app.secret_key = "Secret key don't share pls"

# Connect to blockchain #
truffleFile = json.load(open('../src/abis/addLuggage2.json'))
abi = truffleFile['abi']
bytecode = truffleFile['bytecode']

w3 = Web3(HTTPProvider("http://127.0.0.1:7545"))
print(w3.isConnected())
contract_address = Web3.toChecksumAddress("0x55aa6C459A2d27723dc24f0ffC35AF31E1145309")

contract_instance = w3.eth.contract(abi=abi, address=contract_address)
#########

@app.route("/addUUID/<uuid>", methods=['POST'])
@cross_origin(supports_credentials=True)
def adduuid(uuid):
    user = request.form["user"]
    f = open("uuids.txt", "at")
    f.write(uuid + "\n")
    f.close()
    dbHandler.addUUID(uuid, user)
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
    user = dbHandler.checkUser(request.cookies.get('user'))
    if user:
        return render_template("mainpage1.html")
    else:
        return render_template("mainpage.html")

# @app.route("/1")
# def index1():
#     return render_template("mainpage1.html", username=session["user"])

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
            session["user"] = login
            expire_date = datetime.datetime.now()
            expire_date = expire_date + datetime.timedelta(days=90)
            resp = make_response(redirect(url_for("index")))
            resp.set_cookie('user', login, expires=expire_date)
            return resp
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

@app.route("/logout")
def logout():
    session.pop("user")
    resp = make_response(redirect(url_for("index")))
    resp.delete_cookie('user')
    return resp

@app.route('/static/<path:path>')
def serve_static(path):
    return send_from_directory('static/' + path)

@app.route('/locate', methods=["GET", "POST"])
def locateLuggage():
    uuids = dbHandler.getUUIDs(request.cookies.get('user'))
    print(uuids)
    if request.method == "POST":
        if "uuid" in request.form:
            uuid = request.form["uuid"]
            output = contract_instance.functions.locateMyLuggage(uuid).call()
            o = output.split(" ")
            o[-1] = ": " + dateutil.parser.parse(o[-1]).strftime("%I:%M:%S %p, %-d %b %Y")
            output = " ".join(o)
            return render_template("locate.html", output=output, uuids=uuids)
    else:
        return render_template("locate.html", uuids=uuids)

@app.route('/track', methods=["GET", "POST"])
def trackLuggage():
    uuids = dbHandler.getUUIDs(request.cookies.get('user'))
    print(uuids)
    if request.method == "POST":
        if "uuid" in request.form:
            uuid = request.form["uuid"]
            output = contract_instance.functions.trackLuggage(uuid).call()
            print(output)
            output = output[0].split("\n")[:-1]
            for i in range(len(output)):
                o = output[i].split(" ")
                o[-1] = "::" + dateutil.parser.parse(o[-1]).strftime("%I:%M:%S %p, %-d %b %Y")
                output[i] = " ".join(o)
            print(output)
            return render_template("track.html", output=output, uuids=uuids)
    else:
        return render_template("track.html", uuids=uuids)

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)