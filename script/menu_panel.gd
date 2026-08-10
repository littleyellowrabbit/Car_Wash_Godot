extends Control


@onready var login = $HBoxContainer_SideBar/TextureButton_Login
@onready var user = $HBoxContainer_SideBar/TextureButton_User
@onready var keyparameter = $HBoxContainer_SideBar/TextureButton_KeyParameter
@onready var status = $HBoxContainer_SideBar/TextureButton_Status


func _ready() -> void:
	login.pressed.connect(_on_texture_button_login_pressed)


func _process(delta: float) -> void:
	pass


func _on_texture_button_login_pressed() -> void:
	SignalManager.change_to_login.emit()
	
func _on_texture_button_user_pressed() -> void:
	SignalManager.change_to_user.emit()
	
func _on_texture_button_keyparameter_pressed() -> void:
	SignalManager.change_to_keyparameter.emit()	
	
func _on_texture_button_status_pressed() -> void:
	SignalManager.change_to_status.emit()	
