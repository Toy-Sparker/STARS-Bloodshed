extends Node2D

@onready var level1_load = preload("res://Scenes/Level1.tscn")
@onready var menu_load = preload("res://Scenes/main_menu.tscn")
@onready var enemy = preload("res://Scenes/Enemies/enemy.tscn")
@onready var enemy_strong = preload("res://Scenes/Enemies/enemy_strong.tscn")

var current_enemy = enemy
var enemy_strong_chance = 8
var spawn_rate_decr = 0.02
var prog_time_decr = 0.01

func _ready():
	$SpawnTimer.wait_time = 1.5
	$ProgTimer.wait_time = 5
	$main_menu/MenuLayer/Control/PlayButton.connect("pressed", play_button_pressed)
	$main_menu/MenuLayer/Control/QuitButton.connect("pressed", quit_button_pressed)

func _process(_delta):
	if Global.clock_minutes >= 1:
		enemy_strong_chance = 5
	
	if Global.clock_minutes >= 2:
		enemy_strong_chance = 4
	
	if Global.clock_minutes >= 3:
		enemy_strong_chance = 3
	
	if Global.clock_minutes >= 4:
		enemy_strong_chance = 2

func reset_settings():
	Global.enemies_killed = 0
	Global.game_time = 0
	enemy_strong_chance = 8
	$SpawnTimer.wait_time = 1.5
	$ProgTimer.wait_time = 5

func play_button_pressed():
	var level1_inst = level1_load.instantiate()
	$main_menu/MenuLayer/Control/PlayButton.disconnect("pressed", play_button_pressed)
	$main_menu.queue_free()
	reset_settings()
	Global.game_mode = Global.game_modes.game
	add_child(level1_inst)

func quit_button_pressed():
	get_tree().quit()

func _on_spawn_timer_timeout():
	current_enemy = enemy
	
	if Global.game_mode == Global.game_modes.menu:
		return
	
	if !is_instance_valid(Global.player_node):
		return
	
	if randi_range(1, enemy_strong_chance)>=enemy_strong_chance:
		current_enemy = enemy_strong
	
	var enemy_inst = current_enemy.instantiate()
	var random_point = Vector2(randf(), randf())
	var intensity = 350
	enemy_inst.position.x = Global.player_node.global_position.x + (cos(Time.get_ticks_msec()*2))*intensity*2
	enemy_inst.position.y = Global.player_node.global_position.y + (sin(Time.get_ticks_msec()*2))*intensity
	get_node("Level1").add_child(enemy_inst)

func _on_prog_timer_timeout():
	if Global.game_mode == Global.game_modes.menu:
		return
	
	if !is_instance_valid(Global.player_node):
		return
	
	if $SpawnTimer.wait_time > 0.08:
		$SpawnTimer.wait_time -= spawn_rate_decr
	
	if $ProgTimer.wait_time > 0.06:
		$ProgTimer.wait_time -= prog_time_decr

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel") and Global.game_mode == Global.game_modes.game:
		Global.game_mode = Global.game_modes.menu
		var menu_inst = menu_load.instantiate()
		$Level1.queue_free()
		add_child(menu_inst)
		$main_menu/MenuLayer/Control/PlayButton.connect("pressed", play_button_pressed)
		$main_menu/MenuLayer/Control/QuitButton.connect("pressed", quit_button_pressed)
