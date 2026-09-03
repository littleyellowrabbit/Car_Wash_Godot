extends Node

var http_error = [401,422,500]

var is_refreshing_token = false
signal refresh_completed(success:bool)
#need to imform all in line to wait refresh token 

func send_post(url_path: String, body_dict: Dictionary, needs_auth: bool = true) -> Array:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.timeout = 3.0
	
	var full_url = ReadConfig.api_server_url + url_path
	var headers = ["Content-Type: application/json"]
	if needs_auth:
		#"Authorization: Bearer "Notice after Bearer have space
		headers.append("Authorization: Bearer " + Jwt.access_token)
		
	var body = JSON.stringify(body_dict)
	var error = http_request.request(full_url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		http_request.queue_free()
		return [error, 0, [], PackedByteArray()]
		
	var response = await http_request.request_completed
	http_request.queue_free()
	var response_code = response[1]
	if needs_auth == true and response_code == 401:
		if is_refreshing_token:
			var success = await refresh_completed
			if success:
				return await send_post(url_path, body_dict, needs_auth)
			else:
				return [error, 401, [], PackedByteArray()]
		
		is_refreshing_token = true
		var refresh_result = await _refresh_token()
		is_refreshing_token = false
		refresh_completed.emit(refresh_result)
		
		if refresh_result == true :
			return await send_post(url_path, body_dict, needs_auth)
		else:
			_force_logout()
			SignalManager.change_to_login.emit()
			
	return response
	
	
func _refresh_token() -> bool:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.timeout = 3
	
	var full_url = ReadConfig.api_server_url + "/account/refresh"
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + Jwt.refresh_token
		]
	var body = {}
	
	var err = http_request.request(full_url,headers,HTTPClient.METHOD_POST,body)
	
	if err != OK:
		http_request.queue_free()
		#here may add a sign to tell user internet connect fail.but didn't add.
		return false
	
	var response = await http_request.request_completed
	var response_result = response[0]
	var response_code = response[1]
	var _response_headers = response[2]
	var response_body = response[3]
	
	if response_code == 200 and response_result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.new()
		var parse_err = json.parse(response_body.get_string_from_utf8())
		if parse_err == OK:
			var response_data = json.get_data()
			Jwt.user_id = response_data.get("id",0)
			Jwt.permission = response_data.get("permission","None")
			Jwt.expire_time = response_data.get("exp",0)
			Jwt.access_token = response_data.get("access_token","")
			Jwt.refresh_token = response_data.get("refresh_token","")
			return true
	return false
		
func _force_logout():
	Jwt.logout()
	SignalManager.force_logout.emit()
