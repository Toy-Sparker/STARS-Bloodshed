extends CanvasLayer

@onready var options_menu_inst = preload("res://Scenes/options_menu.tscn").instantiate()
var options_toggle = false

func _ready():
	Global.canvas_node = self

func _process(delta):
	$UI/KillsLabel.text = str(Global.enemies_killed)
	$UI/TimeLabel.text = "Time: " + Global.clock_time(Global.game_time, 0)

func _input(event):
	if Input.is_action_just_pressed("ui_cancel") and Global.game_mode == Global.game_modes.game:
		options_toggle = !options_toggle
		
		if options_toggle:
			add_child(options_menu_inst)
		else:
			remove_child(options_menu_inst)
