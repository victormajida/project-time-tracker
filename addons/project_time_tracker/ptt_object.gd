class_name PTT extends Object

var _data: Dictionary = {}

var time_short_notation := false
var hours_only_notation := false
var options_visible := true
var m1_visible := true
var m2_visible := true
var cs_visible := true
var ls_visible := true
var too_visible := true
var sd_visible := true

func _init():
	_data = PTTUtils.load_data()
	
	var datetime_dict: Dictionary = Time.get_datetime_dict_from_system()
	var now: int = Time.get_unix_time_from_datetime_dict(datetime_dict)
	var date_now: String = PTTUtils.get_date(now)
	var lod: String = _data[PTTUtils.LO]
	if (lod != date_now):
		_data[PTTUtils.LO] = date_now
		_data[PTTUtils.TD] += 1
	
	if _data[PTTUtils.SD] == 0:
		_data[PTTUtils.SD] = now
	
	time_short_notation = _data[PTTUtils.SN]
	hours_only_notation = _data[PTTUtils.HO]
	options_visible = _data[PTTUtils.OP]
	m1_visible = _data[PTTUtils.M1vis]
	m2_visible= _data[PTTUtils.M2vis]
	cs_visible= _data[PTTUtils.HCS]
	ls_visible= _data[PTTUtils.HLS]
	too_visible= _data[PTTUtils.HTD]
	sd_visible= _data[PTTUtils.HSD]

func has_data() -> bool:
	return !_data.is_empty()

func get_data(key):
	return _data[key]

func set_data(key, value):
	_data[key] = value

func increment(key):
	_data[key] += 1

func update_last_session_to_current():
	_data[PTTUtils.LS] = _data[PTTUtils.ST]
