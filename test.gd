# res://HttpManager.gd
extends Node

# 🚀 新增兩行全域狀態控制變數
var _is_refreshing: bool = false



# 自訂一個輕量訊號，用來通知其他正在排隊等待的 401 請求
signal refresh_completed(success: bool)

func send_post(url_path: String, body_dict: Dictionary = {}, needs_auth: bool = true) -> Array:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.timeout = 5.0
	
	var full_url = ReadConfig.api_server_url + url_path
	var headers = ["Content-Type: application/json"]
	if needs_auth:
		headers.append("Authorization: Bearer " + Jwt.access_token)
		
	var body = JSON.stringify(body_dict)
	var error = http_request.request(full_url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		http_request.queue_free()
		return [error, 0, [], PackedByteArray()]
		
	var response = await http_request.request_completed
	http_request.queue_free()
	
	var response_code = response[1]
	
	# ==================== 🎯 核心大絕招：401 自動遞迴與排查打架防線 ====================
	if needs_auth and response_code == 401:
		
		# 💡 狀況一：如果你是慢了一步的 API，發現別人「已經在刷新的路上了」
		if _is_refreshing:
			print("⏳ [HttpManager] 背景已有其他請求正在刷新 Token，本請求暫停並進入排隊...")
			# 🚀 乖乖躺在記憶體裡，等待搶先出發的那個大哥發射「refresh_completed」訊號喚醒你
			var success = await refresh_completed
			
			if success:
				print("🔄 [HttpManager] 排隊小弟被喚醒！Token 已由大哥更新成功，現在直接遞迴重試...")
				return await send_post(url_path, body_dict, needs_auth)
			else:
				# 大哥失敗了，小弟也跟著認命回傳失敗
				return [error, 401, [], PackedByteArray()]
		
		# 💡 狀況二：你是搶先第一名的 API，由你來負責上網衝鋒陷陣！
		print("⚠️ [HttpManager] 偵測到 401 憑證過期！鎖定大門，啟動無感自動續期...")
		_is_refreshing = true # 🔐 鎖上大門！不准後面的連線重複呼叫 API
		
		var refresh_success = await _request_token_refresh()
		
		_is_refreshing = false # 🔓 解鎖大門
		refresh_completed.emit(refresh_success) # 📢 吹哨子通知所有在排隊等候的連線小弟
		
		if refresh_success:
			print("🔄 [HttpManager] 大哥續期成功！現在自動發動『遞迴』，重跑原本的程式...")
			return await send_post(url_path, body_dict, needs_auth)
		else:
			print("❌ [HttpManager] 連 refresh_token 也失效了！必須強迫玩家重新登入。")
			Jwt.clear_auth() # 呼叫全域大掃除
			SignalManager.change_to_login.emit()
			OS.alert("您的登入憑證已失效，請重新登入。", "安全警報")
			return [error, 401, [], PackedByteArray()]
			
	# =========================================================================
	
	return response

# 🔒 私有輔助函數（維持原樣，不需要動）
func _request_token_refresh() -> bool:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	var url = ReadConfig.api_server_url + "/account/refresh"
	var headers = ["Content-Type: application/json", "Authorization: Bearer " + Jwt.refresh_token]
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, "{}")
	if error != OK:
		http_request.queue_free()
		return false
	var response = await http_request.request_completed
	http_request.queue_free()
	
	var response_code = response[1]
	var response_body = response[3]
	if response_code == 200:
		var json = JSON.new()
		if json.parse(response_body.get_string_from_utf8()) == OK:
			var data = json.get_data()
			Jwt.access_token = data.get("access_token", "")
			return true
	return false
