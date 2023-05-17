extends Node2D

@onready var bullet = preload("res://Scenes/Projectiles/bullet.tscn")
var bullet_pierce = 1
var spread_vector = Vector2()
var spread_amount = 0.02
var direction = Vector2()
var damage = 1
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
	$ShootSound.pitch_scale = randf_range(0.8, 1.2)
	$ShootSound.play()
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_position = global_position
	bullet_instance.dir = direction.normalized() + spread_vector
	bullet_instance.damage = damage
	bullet_instance.hp = bullet_pierce
	get_parent().get_parent().get_parent().add_child(bullet_instance)

func level_up(level):
	item_level += 1
	
	match(item_level):
		2:
			spread_amount = 0.06
		4:
			spread_amount = 0.1
			damage += 1
		5:
			spread_amount = 0.15
			bullet_pierce = 2
		6:
			bullet_pierce = 3
			spread_amount = 0.2
		7:
			spread_amount = 0.3
			damage += 1
	
	if $AttackTimer.wait_time > 0.08:
		$AttackTimer.wait_time -= attack_timer_decr
