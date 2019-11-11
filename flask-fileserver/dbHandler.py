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
	cur.execute("SELECT username, password1 FROM users where username=? and password1=?",(username,password1))
	users = cur.fetchall()
	con.close()
	print(users)
	if len(users) == 0:
		return False
	else:
		return users[0][0]

def checkUser(username):
	con = sql.connect("database.db")
	cur = con.cursor()
	cur.execute("SELECT username FROM users where username=?",(username,))
	users = cur.fetchall()
	con.close()
	print(users)
	if len(users) == 0:
		return False
	else:
		return True

# def addUUID(username, uuid):
# 	# Append UUID
# 	pass

# def getUUIDs(username):
# 	return ["35d8eeb6-4143-493e-acf5-50b2b32520c2",
# 	"9a311ffe-1e7f-4e63-ab0b-35383c64e727",
# 	"5e011308-cd6d-438b-84f5-7ab23ed91aa1"]

def getUUIDs(username):
	con=sql.connect("database.db")
	cur=con.cursor()
	cur.execute("SELECT uuid From users where username=?",(username,))
	uuids=cur.fetchall()
	con.close()
	if (not uuids) or (not uuids[0]) or (not uuids[0][0]):
		return []
	else:
		uuids1=uuids[0][0].split(",")
		return uuids1[:-1]

def addUUID(uuid,username):
	con=sql.connect("database.db")
	cur=con.cursor()
	cur.execute("Select uuid From users where username=?",(username,))
	uuids=cur.fetchall()
	# return uuids
	# x=uuid+","
	if not uuids[0][0]:
		uuids = uuid+","
	else:
		uuids=uuids[0][0]+uuid+","
	cur.execute("UPDATE users SET uuid=? where username=?", (uuids,username))
	con.commit()
	con.close()