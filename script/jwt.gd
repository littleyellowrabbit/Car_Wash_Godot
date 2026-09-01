extends Node

var user_id = 0
var permission = ""
var exp = 0
var access_token = ""
var refresh_token =""


func _is_login() -> bool :
	return access_token != ""
	
func logout() -> void:
	user_id = 0
	permission = ""
	exp = 0
	access_token = ""
	refresh_token = ""
