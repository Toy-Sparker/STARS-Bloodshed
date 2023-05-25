extends Node

enum game_modes {
	menu,
	game
}

enum clock {
	none,
	seconds,
	minutes,
	hours
}

var game_paused : bool = false

var game_mode : game_modes = game_modes.menu 

var player_character : String = "base"

var player_node : Object
var canvas_node : Object
var textbox : Object

#var raw_secs = 0
#var raw_mins = 0
#var raw_hours = 0
var global_time = 0
var game_time = 0

var enemies_killed = 0

var snd_vol = -24
var mus_vol = -24

var min_vol = -48

var save_dict : Dictionary = {
	"sound_vol": snd_vol,
	"music_vol": mus_vol,
	"record_time": 0,
	"record_kills": 0
}

func _ready():
	load_file()
	
	AudioServer.set_bus_volume_db(1, mus_vol)
	AudioServer.set_bus_volume_db(2, snd_vol)

func _process(delta):
	global_time += 1*delta
	
	if is_instance_valid(player_node) and !get_tree().paused:
		game_time += 1*delta
	
	clock_time(game_time, clock.none)
	
	bus_mute(snd_vol, 2)
	bus_mute(mus_vol, 1)

func bus_mute(volume, index):
	if volume <= min_vol:
		AudioServer.set_bus_mute(index, true)
	else:
		AudioServer.set_bus_mute(index, false)

func clock_time(time, give_clock_time : clock):
	# Seconds
	var raw_secs = int(floor(time))
	var clock_secs = raw_secs%60
	
	# Minutes
	var raw_mins = int(floor(raw_secs/60))
	var clock_mins = raw_mins%60
	
	# Hours
	var raw_hours = int(floor(raw_mins/60))
	var clock_hrs = raw_hours
	
	if give_clock_time == clock.none:
		return "%02d:%02d" % [clock_mins, clock_secs]
	else:
		match(give_clock_time):
			clock.seconds:
				return raw_secs
			clock.minutes:
				return raw_mins
			clock.hours:
				return raw_hours

func save_file():
	var save_data = FileAccess.open("user://save_file.json", FileAccess.WRITE)
	save_dict["sound_vol"] = snd_vol
	save_dict["music_vol"] = mus_vol
	save_dict["record_time"] = game_time
	save_dict["record_kills"] = enemies_killed
	var json_string = JSON.stringify(save_dict)
	save_data.store_line(json_string)

func load_file():
	if not FileAccess.file_exists("user://save_file.json"):
		return
	
	var save_data = FileAccess.open("user://save_file.json", FileAccess.READ)
	var json_string = save_data.get_line()
	var json = JSON.new()
	
	var _parse_result = json.parse(json_string)
	
	var json_data = json.get_data()
	mus_vol = json_data["music_vol"]
	snd_vol = json_data["sound_vol"]
	save_dict["record_time"] = json_data["record_time"]
	save_dict["record_kills"] = json_data["record_kills"]

func load_data(data):
	if not FileAccess.file_exists("user://save_file.json"):
		return
	
	var save_data = FileAccess.open("user://save_file.json", FileAccess.READ)
	var json_string = save_data.get_line()
	var json = JSON.new()
	
	var _parse_result = json.parse(json_string)
	
	var json_data = json.get_data()
	print(json_data[data])
	return json_data[data]
