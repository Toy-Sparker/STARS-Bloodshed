extends Node2D

@onready var hitscan = preload("res://Scenes/Projectiles/hitscan.tscn")
var bullet_pierce = 1
var spread_vector = Vector2()
var spread_amount = 0.01
var direction = Vector2()
var hitscan_length = 256
var hitscan_size = Vector2(hitscan_length, hitscan_length*0.01)
var damage = 2
var attack_timer_decr = 0.02

var item_level = 1

func _ready():
	EventDispatcher.player_level_up.connect(level_up)

func _process(delta):
	if Input.is_action_pressed("attack") and $AttackTimer.is_stopped():
		$AttackTimer.start()
		attack()

func attack():
	spread_vector.x = randf_range(-spread_amount, spread_amount)
	spread_vector.y = randf_range(-spread_amount, spread_amount)
	$ShootSound.pitch_scale = randf_range(0.7, 0.8)
	$ShootSound.play()
	var hitscan_inst = hitscan.instantiate()
	hitscan_inst.scale = hitscan_size
	hitscan_inst.global_position = global_position
	hitscan_inst.rotation = position.angle_to_point(direction)
	hitscan_inst.damage = damage
	get_parent().get_parent().get_parent().add_child(hitscan_inst)

func level_up(level):
	item_level += 1
	
	match(item_level):
		2:
			pass
		4:
			hitscan_length = 272
		5:
			hitscan_length = 300
			damage = 3
		6:
			hitscan_length = 350
			damage = 4
		7:
			hitscan_length = 400
			damage = 5
	
	hitscan_size = Vector2(hitscan_length, hitscan_length*0.02)
