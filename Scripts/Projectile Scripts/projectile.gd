extends CharacterBody2D

# -- PROJECTILE --

@export var speed = 30000
var dir = Vector2()
@export var hp = 9999
@export var damage = 2

func _process(delta):
	if hp <= 0:
		call_deferred("queue_free")

func _physics_process(delta):
	if speed <= 0:
		return
	
	velocity = dir * speed * delta
	move_and_slide()

func _on_visibility_notifier_screen_exited():
	$Timer.start()

func _on_timer_timeout():
	queue_free()

func _on_life_time_timeout():
	queue_free()
