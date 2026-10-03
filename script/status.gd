extends Node

@onready var lineedit_waterpressure : LineEdit = $VBoxContainer_PresentSet/LineEdit_WaterPressure
@onready var lineedit_foamtype : LineEdit = $VBoxContainer_PresentSet/LineEdit_FoamType
@onready var lineedit_waxtype : LineEdit = $VBoxContainer_PresentSet/LineEdit_WaxType
@onready var lineedit_airpressure : LineEdit = $VBoxContainer_PresentSet/LineEdit_AirPressure

@onready var button_water : Button = $VBoxContainer_MachineHandShake/Button_Water
@onready var button_foam : Button = $VBoxContainer_MachineHandShake/Button_Foam
@onready var button_wax : Button = $VBoxContainer_MachineHandShake/Button_Wax
@onready var button_air : Button = $VBoxContainer_MachineHandShake/Button_Air

@onready var button_standby : Button = $VBoxContainer_HandShake/Button_Standby
@onready var button_preclean : Button = $VBoxContainer_HandShake/Button_PreClean
@onready var button_chemicalsoft : Button = $VBoxContainer_HandShake/Button_ChemicalSoft
@onready var button_physicalclean : Button = $VBoxContainer_HandShake/Button_PhysicalClean
@onready var button_waxprotect : Button = $VBoxContainer_HandShake/Button_WaxProtect
@onready var button_dryair : Button = $VBoxContainer_HandShake/Button_DryAir

@onready var button_start : Button = $Button_Start
@onready var button_stop : Button = $Button_Stop
@onready var label_elapsetime : Label = $Label_ElapseTime

var plc_live_data_old: Dictionary = {}

func _ready() -> void:
	SignalManager.plc_live_data_out.connect(update_ui)
	button_start.pressed.connect(_start_button_pressed)
	button_stop.pressed.connect(_stop_button_pressed)


func update_ui(plc_live_data_newer: Dictionary) -> void:
	var plc_live_data_older = plc_live_data_old
	print(plc_live_data_newer)
	if check_value_change(plc_live_data_newer, plc_live_data_older, 'water_pressure'):
		lineedit_waterpressure.text = str(plc_live_data_newer.get('water_pressure'))
	
	if check_value_change(plc_live_data_newer, plc_live_data_older, 'foam_type'):
		lineedit_foamtype.text = plc_live_data_newer.get('foam_type')
		
	if check_value_change(plc_live_data_newer, plc_live_data_older, 'wax_type'):
		lineedit_waxtype.text = plc_live_data_newer.get('wax_type')

	if check_value_change(plc_live_data_newer, plc_live_data_older, 'air_pressure'):
		lineedit_airpressure.text = str(plc_live_data_newer.get('air_pressure'))
	
	
	
	if check_value_change(plc_live_data_newer, plc_live_data_older, 'water_pressure_used'):
		button_water.button_pressed = plc_live_data_newer.get('water_pressure_used')
		
	if check_value_change(plc_live_data_newer, plc_live_data_older, 'foam_type_used'):
		button_foam.button_pressed = plc_live_data_newer.get('foam_type_used')
		
	if check_value_change(plc_live_data_newer, plc_live_data_older, 'wax_type_used'):
		button_wax.button_pressed = plc_live_data_newer.get('wax_type_used')
		
	if check_value_change(plc_live_data_newer, plc_live_data_older, 'air_pressure_used'):
		button_air.button_pressed = plc_live_data_newer.get('air_pressure_used')
		
		
		
	if check_value_change(plc_live_data_newer, plc_live_data_older, 'standby_status'):
		button_standby.button_pressed = plc_live_data_newer.get('standby_status')
		
	if check_value_change(plc_live_data_newer, plc_live_data_older, 'preclean_status'):
		button_preclean.button_pressed = plc_live_data_newer.get('preclean_status')
	
	if check_value_change(plc_live_data_newer, plc_live_data_older, 'chemical_soft_status'):
		button_chemicalsoft.button_pressed = plc_live_data_newer.get('chemical_soft_status')
	
	if check_value_change(plc_live_data_newer, plc_live_data_older, 'physical_clean_status'):
		button_physicalclean.button_pressed = plc_live_data_newer.get('physical_clean_status')
	
	if check_value_change(plc_live_data_newer, plc_live_data_older, 'wax_protect_status'):
		button_waxprotect.button_pressed = plc_live_data_newer.get('wax_protect_status')
	
	if check_value_change(plc_live_data_newer, plc_live_data_older, 'dry_air_status'):
		button_dryair.button_pressed = plc_live_data_newer.get('dry_air_status')
			
		
	
	if check_value_change(plc_live_data_newer, plc_live_data_older, 'process_start'):
		button_start.visible = not plc_live_data_newer.get('process_start')
		button_stop.visible = plc_live_data_newer.get('process_start')
		
	if plc_live_data_newer.get('process_start'):
		if not plc_live_data_newer.get('process_end_time'):
			label_elapsetime.text = str(int(Time.get_unix_time_from_system() - plc_live_data_newer.get('process_start_time')))
		else:
			label_elapsetime.text = str(int(plc_live_data_newer.get('process_end_time') - plc_live_data_newer.get('process_start_time')))	
	
	plc_live_data_old = plc_live_data_newer.duplicate()
	
	
func check_value_change(plc_live_data_newer: Dictionary, plc_live_data_older: Dictionary, Name: String) -> bool:
	var check_change: bool = false
	if plc_live_data_newer.get(Name) != plc_live_data_older.get(Name):
		check_change = true
	else:
		check_change = false
	return check_change
	
func _start_button_pressed() -> void:	
		var url = "/plc/process_start"
		var body = {
			"Start_Process" : true,
		}
		button_start.disabled = true
		await HttpManager.send_post(url,body,false)
		button_start.disabled = false

func _stop_button_pressed() -> void:	
		var url = "/plc/process_stop"
		var body = {
			"Stop_Process" : true,
		}
		button_stop.disabled = true
		await HttpManager.send_post(url,body,false)
		button_stop.disabled = false
		
