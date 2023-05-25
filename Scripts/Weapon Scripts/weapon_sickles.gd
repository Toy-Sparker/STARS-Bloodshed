extends Node2D

# -- WEAPON - SICKLES --

@onready var melee_load = preload("res://Scenes/Projectiles/melee.tscn")
var direction = Vector2()
var hit_size = Vector2(1, 1)
var damage = 2
var attack_max = 1
var attack_current = 0
var attack_timer_time = 0.8
var attack_timer_decr = 0.05
var attack_dist = 32

var item_level = 1

func _ready():
	EventDispatcher.player_level_up.connect(level_up)

func _process(delta):
	if Input.is_action_pressed("attack") and $AttackTimer.is_stopped():
		attack()
		
		if attack_current == 0:
				$AttackTimer.start(attack_timer_time)
		if attack_current >= 1:
				$AttackTimer.start(attack_timer_time/3)

func attack():
	$MeleeSound.pitch_scale = randf_range(0.98, 1.02)
	$MeleeSound.play()
	var melee_inst = melee_load.instantiate()
	melee_inst.hit_dist = Vector2(attack_dist, 0)
	melee_inst.scale = hit_size
	melee_inst.global_position = global_position
	melee_inst.rotation = position.angle_to_point(direction)
	melee_inst.damage = damage
	get_parent().get_parent().get_parent().add_child(melee_inst)
	
	attack_current += 1
	if attack_current > attack_max:
		attack_current = 0

func level_up(level):
	item_level += 1
	
	match(item_level):
		2:
			hit_size = Vector2(1.2, 1.2)
			attack_dist = 28
		3:
			hit_size = Vector2(1.5, 1.5)
			attack_dist = 24
			damage = 3
		4:
			hit_size = Vector2(1.8, 1.8)
			attack_dist = 20
		5:
			hit_size = Vector2(2.0, 2.0)
		6:
			hit_size = Vector2(2.3, 2.3)
			attack_max = 2
		7:
			hit_size = Vector2(2.4, 2.4)
		8:
			hit_size = Vector2(2.5, 2.5)
		9:
			hit_size = Vector2(2.6, 2.6)
	
	attack_timer_time -= attack_timer_decr
