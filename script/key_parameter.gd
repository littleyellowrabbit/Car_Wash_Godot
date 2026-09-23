extends Control

@onready var vboxcontainer : VBoxContainer = $VBoxContainer
@onready var optionbutton_waterpressure : OptionButton = $VBoxContainer/OptionButton_WaterPressure
@onready var optionbutton_foamtype : OptionButton = $VBoxContainer/OptionButton_FoamType
@onready var optionbutton_waxtype : OptionButton = $VBoxContainer/OptionButton_WaxType
@onready var optionbutton_airpressure : OptionButton = $VBoxContainer/OptionButton_AirPressure
@onready var button_writeparameter : Button = $VBoxContainer/Button_WriteParameter
@onready var label_result : Label = $VBoxContainer/Label_Result

func _ready() -> void:
	_check_login()

func _check_login() -> void:
	if Jwt._is_login() :
		optionbutton_waterpressure.modulate = Color(0.5,0.5,0.5)
		optionbutton_foamtype.modulate = Color(0.5,0.5,0.5)
		optionbutton_waxtype.modulate = Color(0.5,0.5,0.5)
		optionbutton_airpressure.modulate = Color(0.5,0.5,0.5)
		button_writeparameter.modulate = Color(0.5,0.5,0.5)
		
		optionbutton_waterpressure.disabled = true
		optionbutton_foamtype.disabled = true
		optionbutton_waxtype.disabled = true
		optionbutton_airpressure.disabled = true
		button_writeparameter.disabled = true
	else:
		optionbutton_waterpressure.modulate = Color(1,1,1)
		optionbutton_foamtype.modulate = Color(1,1,1)
		optionbutton_waxtype.modulate = Color(1,1,1)
		optionbutton_airpressure.modulate = Color(1,1,1)
		button_writeparameter.modulate = Color(1,1,1)
		
		optionbutton_waterpressure.disabled = false
		optionbutton_foamtype.disabled = false
		optionbutton_waxtype.disabled = false
		optionbutton_airpressure.disabled = false
		button_writeparameter.disabled = false
		
func _write_parameter_button_pressed() -> void:
	var current_time = Time.get_datetime_string_from_system(false,true)
	if (optionbutton_waterpressure.selected != -1 
	and optionbutton_foamtype.selected != -1 
	and optionbutton_waxtype.selected != -1 
	and optionbutton_airpressure.selected != -1):
		
		var url = "/plc/set_parameter"
		var body = {
			"water_pressure" : optionbutton_waterpressure.selected,
			"wax_type" : optionbutton_waxtype.selected,
			"foam_type" : optionbutton_foamtype.selected,
			"air_pressure" : optionbutton_airpressure.selected
		}
		button_writeparameter.disabled = true
		var response_args = await HttpManager.send_post(url,body,true)
		button_writeparameter.disabled = false
		var result = response_args[0]
		var response_code = response_args[1]
		var _response_headers = response_args[2]
		var response_body = response_args[3]
		
		if response_code == 200 and result == HTTPRequest.RESULT_SUCCESS:
			label_result.text= "Set parameter success.\n" + current_time
		elif response_code in HttpManager.http_error:
			label_result.text= "Set parameter fail.\nPlease check connection.\n" + current_time
	else:
		label_result.text= "Program selected wrong \n" + current_time
