extends Control

@onready var lineedit_id : LineEdit = $VBoxContainer/LineEdit_ID
@onready var lineedit_password : LineEdit = $VBoxContainer/LineEdit_Password
@onready var button_login : Button = $VBoxContainer/Button_Login
@onready var button_logout : Button = $VBoxContainer/Button_Logout
@onready var label_result : Label = $VBoxContainer/Label_Result


func _ready() -> void:
	_check_login()

func _check_login() -> void:
	if Jwt._is_login() :
		lineedit_id.visable = false
		lineedit_password.visable =false
		button_login.visible =  false
		button_logout.visible = true
		
	else:
		lineedit_id.visable = true
		lineedit_password.visable =true
		button_login.visible = true
		button_logout.visible = false	

func _result_edit(text:String) -> void:
	label_result.text = text

func _login() -> void:
	
