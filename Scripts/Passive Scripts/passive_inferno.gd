extends Node2D

# -- PASSIVE - INFERNO --

@onready var inferno_load = preload("res://Scenes/Projectiles/inferno_projectile.tscn")

var item_level = 1
var growth = 0.04
var attack_time = 2

func _ready():
	EventDispatcher.player_level_up.connect(level_up)

func _on_timer_timeout():
	$InfernoSound.play()
	var inferno_inst = inferno_load.instantiate()
	inferno_inst.inferno_growth = growth
	get_parent().get_parent().add_child(inferno_inst)
	$Timer.wait_time = attack_time

func level_up(level):
	item_level += 1
	
	match(item_level):
		3:
			growth = 0.06
			attack_time = 1.6
		4:
			growth = 0.07
			attack_time = 1.5
		5:
			growth = 0.08
			attack_time = 1.4
		6:
			growth = 0.1
			attack_time = 1.3
