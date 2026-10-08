extends Control

var scene_login_file = load("res://Login.tscn")
var scene_keyparameter_file = load("res://KeyParameter.tscn")
var scene_user_file = load("res://User.tscn")
var scene_menupanel_file = load("res://MenuPanel.tscn")
var scene_status_file = load("res://Status.tscn")

@onready var side_bar : PanelContainer = $PanelContainer_Up
@onready var main_panel : MarginContainer = $MarginContainer_Main
@onready var scene_login = scene_login_file.instantiate()
@onready var scene_keyparameter = scene_keyparameter_file.instantiate()
@onready var scene_user = scene_user_file.instantiate()
@onready var scene_menupanel = scene_menupanel_file.instantiate()
@onready var scene_status = scene_status_file.instantiate()

func _ready() -> void:
	
	DisplayServer.window_set_size(Vector2i(380, 380))
	var screen_id = DisplayServer.window_get_current_screen()
	var screen_size = DisplayServer.screen_get_size(screen_id)
	var center_pos = (screen_size - Vector2i(380, 380)) / 2
	DisplayServer.window_set_position(center_pos)
	
	
	side_bar.add_child(scene_menupanel)
	main_panel.add_child(scene_status)
	
	SignalManager.change_main_panel_to_login.connect(func(): _change_main_panel(scene_login))
	SignalManager.change_main_panel_to_user.connect(func(): _change_main_panel(scene_user))
	SignalManager.change_main_panel_to_keyparameter.connect(func(): _change_main_panel(scene_keyparameter))
	SignalManager.change_main_panel_to_status.connect(func(): _change_main_panel(scene_status))


func _change_main_panel(scene: Node) -> void:
	if scene_login.get_parent() == main_panel:
		main_panel.remove_child(scene_login)
	if scene_keyparameter.get_parent() == main_panel:
		main_panel.remove_child(scene_keyparameter)
	if scene_user.get_parent() == main_panel:
		main_panel.remove_child(scene_user)
	if scene_status.get_parent() == main_panel:
		main_panel.remove_child(scene_status)
	main_panel.add_child(scene)
