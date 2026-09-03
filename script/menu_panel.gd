extends Control


@onready var texturebutton_login = $HBoxContainer_SideBar/TextureButton_Login
@onready var texturebutton_user = $HBoxContainer_SideBar/TextureButton_User
@onready var texturebutton_keyparameter = $HBoxContainer_SideBar/TextureButton_KeyParameter
@onready var texturebutton_status = $HBoxContainer_SideBar/TextureButton_Status
@onready var label_watchdog = $Label_Watchdog
@onready var label_id = $Label_ID
@onready var label_permission = $Label_Permission

func _ready() -> void:
	update_user_and_permission()
	texturebutton_login.pressed.connect(_on_texture_button_login_pressed)
	texturebutton_user.pressed.connect(_on_texture_button_user_pressed)
	texturebutton_keyparameter.pressed.connect(_on_texture_button_keyparameter_pressed)
	texturebutton_status.pressed.connect(_on_texture_button_status_pressed)
	SignalManager.user_information_signal_out.connect(update_user_and_permission)


func _on_texture_button_login_pressed() -> void:
	SignalManager.change_to_login.emit()
	
func _on_texture_button_user_pressed() -> void:
	SignalManager.change_to_user.emit()
	
func _on_texture_button_keyparameter_pressed() -> void:
	SignalManager.change_to_keyparameter.emit()	
	
func _on_texture_button_status_pressed() -> void:
	SignalManager.change_to_status.emit()	

func update_user_and_permission() -> void:
	if Jwt.permission != "None":
		label_id.text = Jwt.user_name
		label_permission.text = Jwt.permission
		if Jwt.permission in ["Administrator","Engineer"]:
			button_disabled(false,[texturebutton_login,texturebutton_user,texturebutton_keyparameter,texturebutton_status])
		else:
			button_disabled(false,[texturebutton_login,texturebutton_status])
			button_disabled(true,[texturebutton_user,texturebutton_keyparameter])
	else:
		button_disabled(false,[texturebutton_login,texturebutton_status])
		button_disabled(true,[texturebutton_user,texturebutton_keyparameter])
		label_id.text = "None"
		label_permission.text = "None"
		
func button_disabled(disable:bool,button:Array) -> void:
	for btn in button:
				btn.disabled = disable
