@tool
extends Control

@export var lbl_CST: RichTextLabel
@export var lbl_LST: RichTextLabel
@export var lbl_TOOD: RichTextLabel
@export var cb_sn: CheckBox
@export var lbl_StartDate: Label

const PTT_FILE_NAME = "res://ptt.json"

const SD := "sd"    # Tracking Start Date
const ST := "st"    # Current Session Time
const LS := "ls"    # Last Session Time
const TT := "tt"    # Tracking Total Time
const TD := "td"    # Total On/Off Days
const LO := "lo"    # Last Opened Date
const SN := "sn"    # Short Notation Setting

const defaults = { ST: 0, LS: 0, TT: 0, TD: 0, SD: 0, LO: "", SN: false }

const TICK_TIME: float = 1

var elapsed_time: float = 0
var time_short_notation := false

var ptt_data := {}

# Called when the node enters the scene tree for the first time.
func _ready():
	ptt_data = load_data()
	set_process(!ptt_data.is_empty())
	
	if ptt_data.is_empty():
		return
	
	var datetime_dict: Dictionary = Time.get_datetime_dict_from_system()
	var now: int = Time.get_unix_time_from_datetime_dict(datetime_dict)
	var date_now: String = PTTUtils.get_date(now)
	var lod: String = ptt_data[LO]
	if (lod != date_now):
		ptt_data[LO] = date_now
		ptt_data[TD] += 1
	
	if ptt_data[SD] == 0:
		ptt_data[SD] = now
	
	time_short_notation = ptt_data[SN]
	cb_sn.set_pressed_no_signal(time_short_notation)
	
	var str_lst := PTTUtils.bb_text("Last Session", ptt_data[LS], true)
	lbl_LST.text = str_lst
	
	#print("Loaded Data:", ptt_data)

func _process(delta):
	elapsed_time += delta
	if (elapsed_time > TICK_TIME):
		elapsed_time = 0
		ptt_data[ST] += 1
		ptt_data[TT] += 1
		update_ui()

func load_data() -> Dictionary:
	if not FileAccess.file_exists(PTT_FILE_NAME):
		save_data()
	var file = FileAccess.open(PTT_FILE_NAME, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	if data is Dictionary:
		for key in defaults:
			if key not in data:
				data[key] = defaults[key]
		return data
	else:
		printerr("Error loading %s file" % [PTT_FILE_NAME])
		return {}

func save_data():
	#print("Save Data")
	var file = FileAccess.open(PTT_FILE_NAME, FileAccess.WRITE)
	file.store_string(JSON.stringify(ptt_data))
	file.close()

func update_ui():
	var str_cst := PTTUtils.bb_text("Current Session", ptt_data[ST])
	lbl_CST.text = str_cst
	
	var tracked_total_time: int = ptt_data[TT]
	var dhms: String = PTTUtils.secondsToDhms(tracked_total_time, time_short_notation)
	var total_on_off_days: int = ptt_data[TD]
	var YMd: String = PTTUtils.daysToYMD(total_on_off_days)
	var str_days := "Over [color=gold]%s[/color]" % [YMd]
	
	var str_tood := "Combined Time %s\n[color=white]%s[/color]" % [str_days, dhms]
	lbl_TOOD.text = str_tood
	
	var tracking_start_date: String = Time.get_datetime_string_from_unix_time(ptt_data[SD], true)
	lbl_StartDate.text = "Tracking Started:\n%s" % [tracking_start_date]

func _on_check_box_toggled(toggled_on):
	time_short_notation = toggled_on
	ptt_data[SN] = time_short_notation
	update_ui()

func _notification(what): 
	match what:
		NOTIFICATION_EDITOR_POST_SAVE:
			ptt_data[LS] = ptt_data[ST]
			save_data()

func _exit_tree():
	ptt_data[LS] = ptt_data[ST]
	ptt_data[ST] = 0
	save_data()
