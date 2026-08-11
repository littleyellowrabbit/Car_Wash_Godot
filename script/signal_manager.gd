extends Node
signal change_main_panel_to_login()
signal change_to_login()
signal change_main_panel_to_user()
signal change_to_user()
signal change_main_panel_to_keyparameter()
signal change_to_keyparameter()
signal change_main_panel_to_status()
signal change_to_status()

func _ready() -> void:
	change_to_login.connect(_change_main_panel_login)
	change_to_user.connect(_change_main_panel_user)
	change_to_keyparameter.connect(_change_main_panel_keyparameter)
	change_to_status.connect(_change_main_panel_status)

func _process(delta: float) -> void:
	pass

func _change_main_panel_login() -> void:
	change_main_panel_to_login.emit()
	
func _change_main_panel_user() -> void:
	change_main_panel_to_user.emit()
	
func _change_main_panel_keyparameter() -> void:
	change_main_panel_to_keyparameter.emit()

func _change_main_panel_status() -> void:
	change_main_panel_to_status.emit()
