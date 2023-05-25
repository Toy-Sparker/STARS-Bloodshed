extends Node2D

# -- INFERNO --

@onready var dagger_load = preload("res://Scenes/Projectiles/dagger.tscn")

var item_level = 1
var attack_time = 0.5
var attack_time_decr = 0.1
var damage = 2
var angle = 0

func _ready():
	$Timer.wait_time = attack_time
	EventDispatcher.player_level_up.connect(level_up)

func _on_timer_timeout():
	attack()

func attack():
	$DaggerSound.pitch_scale = randf_range(0.9, 1.1)
	$DaggerSound.play()
	var dagger_inst = dagger_load.instantiate()
	dagger_inst.global_position = global_position
	angle += 0.3
	dagger_inst.damage = damage
	dagger_inst.rotation = angle
	dagger_inst.dir = Vector2.from_angle(angle)
	get_parent().get_parent().get_parent().add_child(dagger_inst)
	$Timer.wait_time = attack_time

func level_up(level):
	item_level += 1
	
	if attack_time-attack_time_decr > 0.05:
		attack_time -= attack_time_decr
	
	match(level):
		3:
			attack_time -= 0.04
		4:
			attack_time -= 0.02
		5:
			attack_time -= 0.02
		7:
			attack_time -= 0.01
			damage = 3
		8:
			attack_time -= 0.01
			damage = 4
