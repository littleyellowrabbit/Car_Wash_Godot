extends Node
#token data
var user_id = 0
var permission = "None"
var expire_time = 0
var access_token = ""
var refresh_token =""

var user_name = "None"

func _is_login() -> bool :
	return access_token != ""
	
func logout() -> void:
	user_id = 0
	permission = "None"
	expire_time = 0
	access_token = ""
	refresh_token = ""
	
	user_name = "None"
