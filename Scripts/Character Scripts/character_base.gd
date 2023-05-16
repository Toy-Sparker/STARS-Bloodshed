extends Node2D

@onready var player = get_parent()

var speed = 8000.0

var max_hp = 5
var hp = max_hp

var total_exp = 0
var current_exp = 0
var start_exp = 3

func _ready():
	EventDispatcher.player_level_up.connect(level_up)
	
	set_stats()
	
	player.character = self

func set_stats():
	player.max_hp = max_hp
	player.hp = hp
	
	player.speed = speed
	
	player.total_exp = total_exp
	player.current_exp = current_exp
	player.start_exp = start_exp

func _process(delta):
	pass

func _on_collect_box_area_entered(area):
	player.collect_box(area)

func _on_hurt_box_area_entered(area):
	player.got_hurt()

func level_up(level):
	$CollectBox.scale.x += 0.35
	$CollectBox.scale.y += 0.35
