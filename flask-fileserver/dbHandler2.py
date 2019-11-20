import sqlite3 as sql

def insertUser(username,password1,email):
    con = sql.connect("database.db")
    cur = con.cursor()
    cur.execute("INSERT INTO users (username,password1,email) VALUES (?,?,?)", (username,password1,email))
    con.commit()
    con.close()

def checkLogin(username,password1):
	con = sql.connect("database.db")
	cur = con.cursor()
	cur.execute("SELECT username, password1,email FROM users where username=? and password1=?",(username,password1))
	users = cur.fetchall()
	con.close()
	print(users)
	if len(users) == 0:
		return False
	else:
		return users[0][0]

def getuuid(username):
	con=sql.connect("database.db")
	cur=con.cursor()
	cur.execute("SELECT uuid From users where username=?",(username))
	uuids=cur.fetchall()
	con.close()
	uuids1=uuids.split(",")
	if len(uuids):
		return False
	else:
		return uuids1[:-1]

def appenduuid(username,uuid):
	con=sql.connect("database.db")
	cur=con.cursor()
	cur.execute("Select uuid From users where username=?",(username))
	uuids=cur.fetchall()
	x=uuid+","
	m=uuids[0][0]+x
	cur.execute("UPDATE users SET uuid=? where username=?", (m,username))
	con.commit()
	con.close()


