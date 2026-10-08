extends Node

@onready var tree_userlist : Tree = $HBoxContainer/Tree_UserList
@onready var lineedit_id : LineEdit = $HBoxContainer/VBoxContainer_AdjustUser/LineEdit_ID
@onready var lineedit_password : LineEdit = $HBoxContainer/VBoxContainer_AdjustUser/LineEdit_Password
@onready var optionbutton_permission : OptionButton = $HBoxContainer/VBoxContainer_AdjustUser/OptionButton_Permission
@onready var button_adduser : Button = $HBoxContainer/VBoxContainer_AdjustUser/Button_AddUser
@onready var button_deleteuser : Button = $HBoxContainer/VBoxContainer_AdjustUser/Button_DeleteUser
@onready var label_result : Label = $HBoxContainer/VBoxContainer_AdjustUser/Label_Result

func _ready() -> void:
	button_adduser.pressed.connect(user_add)
	button_deleteuser.pressed.connect(user_delete)
	_update_tree()
	
func _update_tree() -> void:
	tree_userlist.clear()
	var permission: TreeItem = tree_userlist.create_item()
	permission.set_text(0, "Permission")
	permission.set_selectable(0,false)
	
	var administrator: TreeItem = tree_userlist.create_item(permission)
	administrator.set_text(0, "Administrator")
	administrator.set_selectable(0,false)
	var engineer: TreeItem = tree_userlist.create_item(permission)
	engineer.set_text(0, "Engineer")
	engineer.set_selectable(0,false)
	var operator: TreeItem = tree_userlist.create_item(permission)
	operator.set_text(0, "Operator")
	operator.set_selectable(0,false)
	
	var user_list = await _get_user_list()
	for data in user_list:
		if data.get('permission') == 'Administrator':
			var tree_item = tree_userlist.create_item(administrator)
			tree_item.set_text(0,data.get('name'))
		if data.get('permission') == 'Engineer':
			var tree_item = tree_userlist.create_item(engineer)
			tree_item.set_text(0,data.get('name'))
		if data.get('permission') == 'Operator':
			var tree_item = tree_userlist.create_item(operator)
			tree_item.set_text(0,data.get('name'))
	
func _get_user_list() -> Array:
	var url = "/account/user_list"
	var body = {}
	var response_args = await HttpManager.send_get(url,true)
	var result = response_args[0]
	var response_code = response_args[1]
	var _response_headers = response_args[2]
	var response_body = response_args[3]
	if response_code == 200 and result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.new()
		var parse_err = json.parse(response_body.get_string_from_utf8())
		if parse_err == OK:
			var response_data = json.get_data()
			label_result.text = "Tree update success"
			return response_data
		else:
			label_result.text = "Tree update response failed"
			return []
	else:
		return []
			
func user_add() -> void:
	var url = "/account/user_add"
	var body = {
		"name" : lineedit_id.text,
		"password" : lineedit_password.text,
		"permission" : optionbutton_permission.get_item_text(optionbutton_permission.selected)
	}
	button_adduser.disabled = true
	var response_args = await HttpManager.send_post(url,body,true)
	button_adduser.disabled = false
	var result = response_args[0]
	var response_code = response_args[1]
	var _response_headers = response_args[2]
	var response_body = response_args[3]
	if response_code == 200 and result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.new()
		var parse_err = json.parse(response_body.get_string_from_utf8())
		if parse_err == OK:
			await _update_tree()
			label_result.text = "Add user success"
		else:
			label_result.text = "Add user failed"
			
func user_delete() -> void:
	if _on_item_selected() != 'None' :
		var url = "/account/user_delete"
		var body = {
			"name" : _on_item_selected()
		}
		print(_on_item_selected())
		button_deleteuser.disabled = true
		var response_args = await HttpManager.send_delete(url,body,true)
		button_deleteuser.disabled = false
		var result = response_args[0]
		var response_code = response_args[1]
		var _response_headers = response_args[2]
		var response_body = response_args[3]
		if response_code == 200 and result == HTTPRequest.RESULT_SUCCESS:
			var json = JSON.new()
			var parse_err = json.parse(response_body.get_string_from_utf8())
			if parse_err == OK:
				await _update_tree()
				label_result.text = "Delete user success"
			else:
				label_result.text = "Delete user failed"
	else:
		label_result.text = "Delete user failed"

func _on_item_selected() -> String:
	var selected_item: TreeItem = tree_userlist.get_selected()
	var item_content = ''
	if selected_item != null:
		item_content = selected_item.get_text(0)
	else:
		item_content = "None"
	
	return item_content
