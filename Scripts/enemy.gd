extends CharacterBody2D

@export var speed : float = 3000
@export var hp : float = 5
@export var direction : Vector2

@onready var expPoint = preload("res://Scenes/exp_point.tscn") 
@onready var deathSndLoad = preload("res://Sound/Explosion3.wav")

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
	area.get_parent().hp -= 1
	
	flash()
	
	if hp <= 0:
		Global.enemies_killed += 1
		var deathSound = AudioStreamPlayer.new()
		get_parent().add_child(deathSound)
		deathSound.bus = "SFX"
		deathSound.stream = deathSndLoad
		deathSound.finished.connect(queue_free)
		deathSound.play()
		call_deferred("queue_free")

func _on_flash_timer_timeout():
	$Sprite.material.set_shader_parameter("flash_modifier", 0)

func _on_tree_exiting():
	var expPointInst = expPoint.instantiate()
	expPointInst.global_position = global_position
	get_parent().add_child.call_deferred(expPointInst)
