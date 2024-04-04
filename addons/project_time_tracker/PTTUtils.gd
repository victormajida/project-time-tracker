class_name PTTUtils

static func get_date(unix_time: int) -> String:
	return Time.get_date_string_from_unix_time(unix_time)

static func time_format(time: int) -> String:
	var seconds: float = time % 60
	var minutes: float = (time / 60) % 60
	var hours: float = (time / 60) / 60
	
	var str_h := ""
	if hours > 0:
		str_h = "%02d:" % [hours]
	
	var str_m := ""
	if minutes > 0:
		str_m = "%02d:" % [minutes]
	
	var str_s := "%02d" % [seconds]
	
	var str: String = str_h + str_m + str_s
	
	return str

static func secondsToDhms(seconds: int, short_notation: bool = false) -> String:
	var d: float = seconds / (3600 * 24)
	var h: float = fmod(seconds, 3600 * 24) / 3600
	var m: float = fmod(seconds, 3600) / 60
	var s: float = fmod(seconds, 60)
	
	var dDisplay: String = check_plural("day", d, short_notation)
	var hDisplay: String = check_plural("hour", h, short_notation)
	var mDisplay: String = check_plural("minute", m, short_notation)
	var sDisplay: String = check_plural("second", s, short_notation)
	
	var display: String = dDisplay + hDisplay + mDisplay + sDisplay
	display = display.left(-2)
	return "~ " + display

static func daysToYMD(days: int, short_notation: bool = false) -> String:
	var Y: float = days / 365
	var M: float = (days % 365) / 30.4167
	var d: float = fmod((days % 365), 30.4167)
	
	var YDisplay: String = check_plural("Year", Y, short_notation)
	var MDisplay: String = check_plural("Month", M, short_notation)
	var dDisplay: String = check_plural("Day", d, short_notation)
	
	var display: String = YDisplay + MDisplay + dDisplay
	display = display.left(-2)
	return display
	
static func check_plural(str: String, num: int, short: bool = false) -> String:
	var display := ""
	if num > 0:
		var result: String = str if (num == 1) else (str + "s")
		display = "%d%s, " % [num, result[0]] if short else "%d %s, " % [num, result]
	return display

static func color_temp(session_time: int) -> String:
	var str_color := "green"
	
	if (session_time > 14400):
		str_color = "red"
	elif (session_time > 10800):
		str_color = "coral"
	elif (session_time > 7200):
		str_color = "yellow"
	elif (session_time > 3600):
		str_color = "green_yellow"
		
	return str_color

static func bb_text(title: String, time: float, dhms: bool = false) -> String:
	var _time_format: String = time_format(time)
	if (dhms):
		_time_format = secondsToDhms(time, true)
	var _bb_color: String = color_temp(time)
	var _str := "[center]%s\n[color=%s]%s[/color][/center]" % [title, _bb_color, _time_format]
	return _str
