extends Node

enum game_modes {
	menu,
	game
}

var game_mode : game_modes = game_modes.menu 

var player_node : Object
var canvas_node : Object

var raw_secs = 0
var raw_mins = 0
var raw_hours = 0

var clock_seconds = 0
var clock_minutes = 0
var clock_hours = 0
var game_time = 0

var enemies_killed = 0

func _ready():
	EventDispatcher.player_level_up.connect(level_up)

func _process(delta):
	if is_instance_valid(player_node):
		game_time += 1*delta
	
	# Seconds
	raw_secs = int(floor(game_time))
	clock_seconds = raw_secs%60
	
	# Minutes
	raw_mins = int(floor(raw_secs/60))
	clock_minutes = raw_mins%60
	
	# Hours
	raw_hours = int(floor(raw_mins/60))
	clock_hours = raw_hours

func level_up(level):
	match(level):
		3:
			var passive_inferno_inst = load("res://Scenes/Weapons/passive_inferno.tscn").instantiate()
			Global.player_node.get_node("Passives").add_child(passive_inferno_inst)
