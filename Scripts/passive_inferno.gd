extends Node2D

@onready var inferno_load = preload("res://Scenes/inferno_projectile.tscn")

var item_level = 1
var damage = 2
var growth = 0.04
var attack_time = 2

func _ready():
	EventDispatcher.player_level_up.connect(level_up)

func _on_timer_timeout():
	var inferno_inst = inferno_load.instantiate()
	inferno_inst.damage = damage
	inferno_inst.inferno_growth = growth
	get_parent().get_parent().add_child(inferno_inst)
	$Timer.wait_time = attack_time

func level_up(level):
	item_level += 1
	
	match(item_level):
		2:
			damage = 3
		3:
			growth = 0.06
			attack_time = 1.6
		4:
			growth = 0.07
			damage = 4
			attack_time = 1.5
		5:
			growth = 0.08
			damage = 5
			attack_time = 1.4
		6:
			growth = 0.1
			damage = 6
			attack_time = 1.3
	
	print("INFERNO NOW HAS: "  + str(damage) + " damage")
	print(str(growth) + " growth")
	print(str(attack_time) + " attack delay")
