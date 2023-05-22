extends "res://Scripts/Projectile Scripts/projectile.gd"

var shockwave_growth = 0.1
var life_time = 0.3

func _ready():
	$LifeTime.start(life_time)

func _process(delta):
	scale += Vector2(shockwave_growth, shockwave_growth)
	
	if $LifeTime.get_time_left() < life_time/2:
		modulate.a = max(modulate.a - life_time*0.2, 0)
	
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
