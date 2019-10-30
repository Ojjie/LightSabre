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
	if len(users) == 0:
		return False
	else:
		return True