extends Control

@export var lbl_st: Label
@export var lbl_taa: Label
@export var lbl_taas: Label
@export var lbl_tp: Label
@export var lbl_tps: Label

func _ready():
	print("")
	var st = PTTUtils.tracking_start_time()
	#print("Start Time TimeStamp: ", st)
	lbl_st.text = "%s" % st
	var taa = PTTUtils.total_active_time()
	#print("Total Active Time: ", taa)
	lbl_taa.text = "%d" % taa
	var taas = PTTUtils.total_active_time_string()
	#print("Total Active Time String: ", taas)
	lbl_taas.text = "%s" % taas
	var tp = PTTUtils.total_period()
	#print("Total Period: ", tp)
	lbl_tp.text = "%d" % tp
	var tps = PTTUtils.total_period_string("Gone")
	#print("Total Period String: ", tps)
	lbl_tps.text = "%s" % tps
