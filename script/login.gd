extends Control

@onready var lineedit_id : LineEdit = $VBoxContainer/LineEdit_ID
@onready var lineedit_password : LineEdit = $VBoxContainer/LineEdit_Password
@onready var button_login : Button = $VBoxContainer/Button_Login
@onready var button_logout : Button = $VBoxContainer/Button_Logout
@onready var label_result : Label = $VBoxContainer/Label_Result

func _ready() -> void:
	_check_login()
	button_login.pressed.connect(_login_button_pressed)
	button_logout.pressed.connect(_logout_button_pressed)
	
	SignalManager.force_logout_signal.connect(_force_logout)

func _check_login() -> void:
	if Jwt._is_login() :
		lineedit_id.visible = false
		lineedit_password.visible =false
		button_login.visible =  false
		button_logout.visible = true
	else:
		lineedit_id.visible = true
		lineedit_password.visible =true
		button_login.visible = true
		button_logout.visible = false	
	SignalManager.user_information_signal_in.emit()

func _result_edit(text:String) -> void:
	label_result.text = text

func _login_button_pressed() -> void:
	var url = "/account/login"
	var body = {
		"name" : lineedit_id.text,
		"password" : lineedit_password.text
	}
	button_login.disabled = true
	var response_args = await HttpManager.send_post(url,body,false)
	button_login.disabled = false
	var result = response_args[0]
	var response_code = response_args[1]
	var _response_headers = response_args[2]
	var response_body = response_args[3]
	if response_code == 200 and result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.new()
		var parse_err = json.parse(response_body.get_string_from_utf8())
		if parse_err == OK:
			var response_data = json.get_data()
			Jwt.user_id = response_data.get("id",0)
			Jwt.permission = response_data.get("permission","None")
			Jwt.expire_time = response_data.get("exp",0)
			Jwt.access_token = response_data.get("access_token","")
			Jwt.refresh_token = response_data.get("refresh_token","")
			Jwt.user_name = lineedit_id.text
			SignalManager.change_to_status.emit()
			lineedit_id.text=""
			lineedit_password.text=""
			_check_login()
			_result_edit("Login success")
		else:
			_result_edit("login response failed.parse failed")
	elif response_code in HttpManager.http_error:
		var json = JSON.new()
		var parse_err = json.parse(response_body.get_string_from_utf8())
		if parse_err == OK:
			var response_data = json.get_data()
			_result_edit(response_data.get("detail",""))
		else:
			_result_edit("login failed.parse error failed")
	else:
		_result_edit("login failed.please check connect.")
		
		
func _logout_button_pressed():
	var url = "/account/logout"
	var body ={}
	button_logout.disabled = true
	var response_args = await HttpManager.send_post(url,body,true)
	button_logout.disabled = false
	lineedit_id.text=""
	lineedit_password.text=""
	Jwt.logout()
	_check_login()
	var result = response_args[0]
	var response_code = response_args[1]
	var _response_headers = response_args[2]
	var response_body = response_args[3]
	
	if response_code == 200 and result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.new()
		var parse_err = json.parse(response_body.get_string_from_utf8())
		if parse_err == OK:
			var response_data = json.get_data()
			_result_edit(response_data.get("detail",""))
		else:
			_result_edit("logout response failed.parse failed")
	elif response_code in HttpManager.http_error:
		var json = JSON.new()
		var parse_err = json.parse(response_body.get_string_from_utf8())
		if parse_err == OK:
			var response_data = json.get_data()
			_result_edit(response_data.get("detail",""))
		else:
			_result_edit("logout failed.parse error failed")
	else:
		_result_edit("logout failed.please check connect.")
	
func _force_logout() -> void:
	lineedit_id.text=""
	lineedit_password.text=""
	_check_login()
			
