extends Node2D

# -- PASSIVE - SHOCKWAVE --

@onready var shockwave_load = preload("res://Scenes/Projectiles/shockwave_projectile.tscn")

var item_level = 1
var growth = 0.1
var attack_time = 2

func _ready():
	EventDispatcher.player_level_up.connect(level_up)

func _on_timer_timeout():
	$ShockwaveSound.play()
	var shockwave_inst = shockwave_load.instantiate()
	shockwave_inst.shockwave_growth = growth
	get_parent().get_parent().add_child(shockwave_inst)
	$Timer.wait_time = attack_time

func level_up(level):
	item_level += 1
	
	match(item_level):
		3:
			growth = 0.14
			attack_time = 1.6
		4:
			growth = 0.18
			attack_time = 1.5
		5:
			growth = 0.22
			attack_time = 1.4
		6:
			growth = 0.26
			attack_time = 1.3
