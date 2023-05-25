extends CharacterBody2D

@export var death_anim : String = "enemy1"
@export var speed : float = 3000
@export var hp : float = 5
@export var attack : float = 1
@export var direction : Vector2
@export var custom_drops = false
@export var drop_chances : Array = [
	{
		"type": "points",
		"red_chance": 0,
		"green_chance": 0,
		"purple_chance": 0,
	}
]

@onready var expPoint = preload("res://Scenes/exp_point.tscn") 
@onready var deathSnd = lib.enemy_sounds.get("death")

func _physics_process(delta):
	if !is_instance_valid(Global.player_node):
		return
	
	direction = global_position.direction_to(Global.player_node.global_position)
	velocity = direction*speed*delta
	move_and_slide()

func flash():
	$Sprite.material.set_shader_parameter("flash_modifier", 1)
	$FlashTimer.start()

func _on_hurt_box_area_entered(area):
	$HurtSound.play()
	
	hp -= area.get_parent().damage
	area.get_parent().hp -= attack
	
	flash()
	
	if hp <= 0:
		Global.enemies_killed += 1
		var deathSound = AudioStreamPlayer.new()
		get_parent().add_child(deathSound)
		deathSound.bus = "SFX"
		deathSound.stream = deathSnd
		var pitch_shift = 0.1
		deathSound.pitch_scale = randf_range(1 - pitch_shift, 1 + pitch_shift)
		deathSound.finished.connect(deathSound.queue_free)
		deathSound.play()
		
		var enemy_explode = lib.enemy_explode_scene.instantiate()
		enemy_explode.anim = death_anim
		enemy_explode.global_position = global_position
		get_parent().add_child(enemy_explode)
		call_deferred("queue_free")

func _on_flash_timer_timeout():
	$Sprite.material.set_shader_parameter("flash_modifier", 0)

func _on_tree_exiting():
	var expPointInst = expPoint.instantiate()
	expPointInst.global_position = global_position
	
	if custom_drops == true:
		if drop_chances[0].get("type") == "points":
			expPointInst.red_chance = drop_chances[0].get("red_chance")
			expPointInst.green_chance = drop_chances[0].get("green_chance")
			expPointInst.purple_chance = drop_chances[0].get("purple_chance")
	
	get_parent().add_child.call_deferred(expPointInst)
