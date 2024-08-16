@tool
extends Control

@export var lbl_CST: RichTextLabel
@export var lbl_LST: RichTextLabel
@export var lbl_TOOD: RichTextLabel
@export var lbl_M1T: RichTextLabel
@export var lbl_M2T: RichTextLabel
@export var cb_sn: CheckBox
@export var cb_ho: CheckBox
@export var M1_button: Button
@export var M2_button: Button
@export var lbl_StartDate: Label
@export var m1_container: VBoxContainer
@export var m2_container: VBoxContainer
@export var options_container: GridContainer
@export_category("Options")
@export var cb_show_options: Button
@export var cb_hideM1: CheckBox
@export var cb_hideM2: CheckBox
@export var cb_hidecs: CheckBox
@export var cb_hidels: CheckBox
@export var cb_hidetoo: CheckBox
@export var cb_hidesd: CheckBox

const TICK_TIME: float = 1

var elapsed_time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if !PTTUtils.ptt.has_data():
		printerr("Couldn't launch Project Time Tracker. Data file empty!")
		return
	
	set_process(PTTUtils.ptt.has_data())
	
	cb_sn.set_pressed_no_signal(PTTUtils.ptt.time_short_notation)
	cb_ho.set_pressed_no_signal(PTTUtils.ptt.hours_only_notation)
	cb_show_options.set_pressed(PTTUtils.ptt.options_visible)
	cb_hideM1.set_pressed(PTTUtils.ptt.m1_visible)
	cb_hideM2.set_pressed(PTTUtils.ptt.m2_visible)
	cb_hidecs.set_pressed(PTTUtils.ptt.cs_visible)
	cb_hidels.set_pressed(PTTUtils.ptt.ls_visible)
	cb_hidetoo.set_pressed(PTTUtils.ptt.too_visible)
	cb_hidesd.set_pressed(PTTUtils.ptt.sd_visible)
	
	var str_lst := PTTUtils.bb_text("Last Session", PTTUtils.ptt.get_data(PTTUtils.LS), true)
	lbl_LST.text = str_lst

func _process(delta):
	elapsed_time += delta
	if (elapsed_time > TICK_TIME):
		elapsed_time = 0
		PTTUtils.ptt.increment(PTTUtils.ST)
		PTTUtils.ptt.increment(PTTUtils.TT)
		PTTUtils.ptt.increment(PTTUtils.M1)
		PTTUtils.ptt.increment(PTTUtils.M2)
		
		update_ui()

func update_ui():
	var str_cst := PTTUtils.bb_text("Current Session", PTTUtils.ptt.get_data(PTTUtils.ST))
	lbl_CST.text = str_cst
	
	var tracked_total_time: int = PTTUtils.ptt.get_data(PTTUtils.TT)
	var m1_tracked_total_time: int = PTTUtils.ptt.get_data(PTTUtils.M1)
	var m2_tracked_total_time: int = PTTUtils.ptt.get_data(PTTUtils.M2)
	var dhms: String = PTTUtils.secondsToDhms(tracked_total_time, PTTUtils.ptt.time_short_notation, PTTUtils.ptt.hours_only_notation)
	var m1dhms: String = PTTUtils.secondsToDhms(m1_tracked_total_time, PTTUtils.ptt.time_short_notation, PTTUtils.ptt.hours_only_notation)
	var m2dhms: String = PTTUtils.secondsToDhms(m2_tracked_total_time, PTTUtils.ptt.time_short_notation, PTTUtils.ptt.hours_only_notation)
	var total_on_off_days: int = PTTUtils.ptt.get_data(PTTUtils.TD)
	var YMd: String = PTTUtils.daysToYMD(total_on_off_days)
	var str_days := "Over [color=gold]%s[/color]" % [YMd]
	
	
	var str_tood := "Combined Time %s\n[color=white]%s[/color]" % [str_days, dhms]
	lbl_TOOD.text = str_tood
	
	var str_m1 := "[center]Time Since Milestone 1\n[color=white]%s[/color]" % [m1dhms]
	lbl_M1T.text = str_m1
	
	var str_m2 := "[center]Time Since Milestone 2\n[color=white]%s[/color]" % [m2dhms]
	lbl_M2T.text = str_m2
	
	var tracking_start_date: String = Time.get_datetime_string_from_unix_time(PTTUtils.ptt._data[PTTUtils.SD], true)
	lbl_StartDate.text = "Tracking Started:\n%s" % [tracking_start_date]

func _on_check_box_toggled(toggled_on):
	PTTUtils.ptt.time_short_notation = toggled_on
	PTTUtils.ptt.set_data(PTTUtils.SN, PTTUtils.ptt.time_short_notation)
	
	update_ui()

func _notification(what): 
	match what:
		NOTIFICATION_EDITOR_POST_SAVE:
			PTTUtils.ptt.update_last_session_to_current()
			PTTUtils.save_data()

func _exit_tree():
	PTTUtils.ptt.update_last_session_to_current()
	PTTUtils.ptt.set_data(PTTUtils.ST, 0)
	PTTUtils.save_data()


func _on_hours_only_check_box_toggled(toggled_on):
	PTTUtils.ptt.hours_only_notation = toggled_on
	PTTUtils.ptt.set_data(PTTUtils.HO, PTTUtils.ptt.hours_only_notation)
	
	update_ui()


func _on_set_m_1_button_pressed():
	PTTUtils.ptt.set_data(PTTUtils.M1, 0)


func _on_set_m_2_button_pressed():
	PTTUtils.ptt.set_data(PTTUtils.M2, 0)


func _on_hide_m_1_toggled(toggled_on):
	PTTUtils.ptt.m1_visible= toggled_on
	PTTUtils.ptt.set_data(PTTUtils.M1vis, PTTUtils.ptt.m1_visible)
	m1_container.visible= PTTUtils.ptt.m1_visible


func _on_hide_m_2_toggled(toggled_on):
	PTTUtils.ptt.m2_visible= toggled_on
	PTTUtils.ptt.set_data(PTTUtils.M2vis, PTTUtils.ptt.m2_visible)
	m2_container.visible= PTTUtils.ptt.m2_visible


func _on_options_check_box_toggled(toggled_on):
	PTTUtils.ptt.options_visible= toggled_on
	PTTUtils.ptt.set_data(PTTUtils.OP, PTTUtils.ptt.options_visible)
	options_container.visible= PTTUtils.ptt.options_visible
	if toggled_on:
		cb_show_options.text= "Hide Options"
	else:
		cb_show_options.text= "Show Options"


func _on_hide_cs_toggled(toggled_on):
	PTTUtils.ptt.cs_visible= toggled_on
	PTTUtils.ptt.set_data(PTTUtils.HCS, PTTUtils.ptt.cs_visible)
	lbl_CST.visible= PTTUtils.ptt.cs_visible


func _on_hide_ls_toggled(toggled_on):
	PTTUtils.ptt.ls_visible= toggled_on
	PTTUtils.ptt.set_data(PTTUtils.HLS, PTTUtils.ptt.ls_visible)
	lbl_LST.visible= PTTUtils.ptt.ls_visible


func _on_hide_total_on_off_toggled(toggled_on):
	PTTUtils.ptt.too_visible= toggled_on
	PTTUtils.ptt.set_data(PTTUtils.HTD, PTTUtils.ptt.too_visible)
	lbl_TOOD.visible= PTTUtils.ptt.too_visible


func _on_hide_start_date_toggled(toggled_on):
	PTTUtils.ptt.sd_visible= toggled_on
	PTTUtils.ptt.set_data(PTTUtils.HSD, PTTUtils.ptt.sd_visible)
	lbl_StartDate.visible= PTTUtils.ptt.sd_visible
