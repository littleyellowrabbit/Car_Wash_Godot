extends Node

var websocket_url = ReadConfig.api_server_url + "/plc/real_time_data"
var socket = WebSocketPeer.new()

var reconnect_timer = 0
var RECONNECT_DELAY = 3

func _ready() -> void:
	_try_connect()

func _process(delta: float) -> void:
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		reconnect_timer = 0
		while socket.get_available_packet_count() > 0:
			var packet = socket.get_packet()
			var json_string = packet.get_string_from_utf8()
			var json = JSON.new()
			var parse_err = json.parse(json_string)
			if parse_err == OK:
				var live_data = json.get_data()
				_update_data(live_data)
	elif state == WebSocketPeer.STATE_CLOSED or state != WebSocketPeer.STATE_CONNECTING:
		reconnect_timer += delta
		if reconnect_timer > RECONNECT_DELAY :
			reconnect_timer = 0
			_try_connect()
				
			
func _try_connect() -> void:
	var err = socket.connect_url(websocket_url)
	if err == OK:
		SignalManager.websocket_connection_in.emit(true)
	else:
		SignalManager.websocket_connection_in.emit(false)

func _update_data(data: Dictionary) -> void:
	SignalManager.plc_live_data_in.emit(data)
	
	
