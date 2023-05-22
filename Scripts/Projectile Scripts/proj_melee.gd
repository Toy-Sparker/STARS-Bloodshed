extends CharacterBody2D

# -- PROJECTILE - MELEE --

@export var speed = 0
var dir = Vector2()
@export var hp = 9999
@export var damage = 2
var hit_dist = Vector2()

func _ready():
	$Marker.position = hit_dist

func _process(delta):
	modulate.a = max(modulate.a - 0.1, 0)
	
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
