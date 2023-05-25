extends AnimatedSprite2D

var anim = "enemy1"

func _ready():
	play(anim)

func _on_animation_finished():
	queue_free()
