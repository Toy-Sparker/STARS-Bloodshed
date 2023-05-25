extends Node2D

# -- WEAPON - REVOLVER --

@onready var hitscan_load = preload("res://Scenes/Projectiles/hitscan.tscn")
var spread_vector : Vector2
var spread_amount = 0.01
var direction : Vector2
var hitscan_length = 256
var hitscan_width = 0.02
var hitscan_size : Vector2
var damage = 2
var attack_timer_time = 0.75
var attack_timer_decr = 0.05

var item_level = 1

func _ready():
	hitscan_set()
	EventDispatcher.player_level_up.connect(level_up)

func _process(delta):
	if Input.is_action_pressed("attack") and $AttackTimer.is_stopped():
		attack()
		$AttackTimer.start(attack_timer_time)

func attack():
	spread_vector.x = randf_range(-spread_amount, spread_amount)
	spread_vector.y = randf_range(-spread_amount, spread_amount)
	$ShootSound.pitch_scale = randf_range(0.98, 1.02)
	$ShootSound.play()
	var hitscan_inst = hitscan_load.instantiate()
	hitscan_inst.scale = hitscan_size
	hitscan_inst.global_position = global_position
	hitscan_inst.rotation = position.angle_to_point(direction)
	hitscan_inst.damage = damage
	get_parent().get_parent().get_parent().add_child(hitscan_inst)

func hitscan_set():
	hitscan_size = Vector2(hitscan_length, hitscan_length*hitscan_width)

func level_up(level):
	item_level += 1
	
	match(item_level):
		2:
			hitscan_length = 275
		3:
			hitscan_length = 290
		4:
			hitscan_length = 320
		5:
			damage = 3
			hitscan_length = 360
		6:
			damage = 4
			hitscan_width = 0.03
			hitscan_length = 400
		7:
			hitscan_width = 0.04
			hitscan_length = 420
			damage = 6
		8:
			attack_timer_time -= 0.1
			hitscan_width = 0.05
			hitscan_length = 450
			damage = 8
		9:
			hitscan_length = 475
			hitscan_width = 0.06
			damage = 12
		10:
			hitscan_length = 500
			damage = 15
	
	hitscan_set()
