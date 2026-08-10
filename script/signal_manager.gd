extends Node
signal change_main_panel_to_login(),change_to_login()
signal change_to_login()

func _ready() -> void:
	change_to_login.connect(_change_main_panel_login)

func _process(delta: float) -> void:
	pass

func _change_main_panel_login() -> void:
	change_main_panel_to_login.emit()
