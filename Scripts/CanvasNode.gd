extends CanvasLayer

func _ready():
	Global.canvas_node = self

func _process(delta):
	$UI/KillsLabel.text = str(Global.enemies_killed)
	$UI/TimeLabel.text = "Time: " + "%02d:%02d" % [Global.clock_minutes, Global.clock_seconds]
