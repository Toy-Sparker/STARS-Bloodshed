extends CanvasLayer

@onready var options_menu_inst = preload("res://Scenes/options_menu.tscn").instantiate()
var options_toggle = false

func _ready():
	Global.canvas_node = self

func _process(_delta):
	$UI/KillsLabel.text = str(Global.enemies_killed)
	$UI/TimeLabel.text = "Time: " + Global.clock_time(Global.game_time, Global.clock.none)

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel") and Global.game_mode == Global.game_modes.game:
		options_toggle = !options_toggle
		
		if options_toggle:
			EventDispatcher.game_pause.emit(true)
			get_tree().paused = true
			add_child(options_menu_inst)
		else:
			EventDispatcher.game_pause.emit(false)
			get_tree().paused = false
			remove_child(options_menu_inst)
