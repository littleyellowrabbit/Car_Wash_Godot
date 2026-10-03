extends Node

var api_server_url : String = ""
var api_server_url_web : String = ""

func _ready() -> void:
	var file_path = "res://config/config.json"
	if FileAccess.file_exists(file_path):
		var file_string = FileAccess.get_file_as_string(file_path)
		var json = JSON.new()
		if json.parse(file_string) == OK:
			var data = json.get_data()
			if data is Dictionary:
				api_server_url = data.get("api_server_url")
				api_server_url_web = data.get("api_server_url_web")
