extends Node

@onready var tree_userlist : Tree = $HBoxContainer/Tree_UserList
@onready var lineedit_id : LineEdit = $HBoxContainer/VBoxContainer_AdjustUser/LineEdit_ID
@onready var lineerid_password : LineEdit = $HBoxContainer/VBoxContainer_AdjustUser/LineEdit_Password
@onready var optionbutton_permission : OptionButton = $HBoxContainer/VBoxContainer_AdjustUser/OptionButton_Permission
@onready var button_adduser : Button = $HBoxContainer/VBoxContainer_AdjustUser/Button_AddUser
@onready var button_deleteuser : Button = $HBoxContainer/VBoxContainer_AdjustUser/Button_DeleteUser
@onready var label_result : Label = $HBoxContainer/VBoxContainer_AdjustUser/Label_Result

func _ready() -> void:
	tree_userlist.item_selected.connect(_on_item_selected)
	# 1. 必須先建立「根節點」（Root），這是所有項目的起點
	var root: TreeItem = tree_userlist.create_item()
	root.set_text(0, "我的知識庫") # 0 代表第一欄（Column）
	root.set_text(1, "QQ") # 0 代表第一欄（Column）
	
	# 2. 建立第一層子節點（家長是 root）
	var category1: TreeItem = tree_userlist.create_item(root)
	category1.set_text(0, "程式語言")
	
	var category2: TreeItem = tree_userlist.create_item(root)
	category2.set_text(0, "遊戲美術")
	
	# 3. 建立第二層子節點（家長是 category1）
	var sub_item1: TreeItem = tree_userlist.create_item(category1)
	sub_item1.set_text(0, "GDScript")
	# 你還可以為它綁定隱藏的自訂資料（例如資料庫 ID 或物件）
	sub_item1.set_metadata(0, {"id": 101, "type": "script"})
	
	var sub_item2: TreeItem = tree_userlist.create_item(category1)
	sub_item2.set_text(0, "C#")

func _on_item_selected() -> void:
	# 獲取目前被選取的 TreeItem
	var selected_item: TreeItem = tree_userlist.get_selected()
	
	if selected_item:
		# 讀取顯示的文字
		var text = selected_item.get_text(0)
		# 讀取隱藏的綁定資料
		var metadata = selected_item.get_metadata(0)
		
		print("玩家點擊了：", text)
		print("附帶的資料為：", metadata)


func _update_tree() -> void:
	
	
	"""
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
	"""
