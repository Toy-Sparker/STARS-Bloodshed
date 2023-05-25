extends Area2D

var exp_amount = 1
var pickup_pitch = 0.75

var red_chance = 6
var green_chance = -1
var purple_chance = -1

var heal = 0

var current_sound = lib.exp_sounds.get("point1")
var custom_drop = false

func _ready():
	point_progression()
	
	point_rarity()

func point_progression():
	if custom_drop == true:
		return
	
	if Global.clock_time(Global.game_time, Global.clock.minutes) >= 1:
		green_chance = 10
	
	if Global.clock_time(Global.game_time, Global.clock.minutes) >= 2:
		red_chance = 3
	
	if Global.clock_time(Global.game_time, Global.clock.minutes) >= 3:
		green_chance = 6
	
	if Global.clock_time(Global.game_time, Global.clock.minutes) >= 4:
		red_chance = 2
	
	if Global.clock_time(Global.game_time, Global.clock.minutes) >= 5:
		green_chance = 5
	
	if Global.clock_time(Global.game_time, Global.clock.minutes) >= 4:
		green_chance = 4
	
	if Global.clock_time(Global.game_time, Global.clock.minutes) >= 3:
		green_chance = 3

func point_rarity():
	if red_chance == -1:
		return
	
	# Chance of red points
	if randi_range(1, red_chance) >= red_chance:
		$Sprite.texture = load("res://Sprites/exp_point_2.png")
		exp_amount = 3
		pickup_pitch = 1
	
	if green_chance == -1:
		return
	
	# Chance of green points
	if randi_range(1, green_chance) >= green_chance:
		$Sprite.texture = load("res://Sprites/exp_point_3.png")
		exp_amount = 10
		pickup_pitch = 1.5
	
	if purple_chance == -1:
		return
	
	if randi_range(1, purple_chance) >= purple_chance:
		$Sprite.texture = load("res://Sprites/exp_point_4.png")
		exp_amount = 300
		pickup_pitch = 1
		heal = 2
		current_sound = lib.exp_sounds.get("point2")

func play_sound(sound, pitch : float = 1):
	var pickupSoundPlayer = AudioStreamPlayer.new()
	get_parent().add_child(pickupSoundPlayer)
	pickupSoundPlayer.bus = "SFX"
	pickupSoundPlayer.stream = sound
	pickupSoundPlayer.pitch_scale = pitch
	pickupSoundPlayer.finished.connect(pickupSoundPlayer.queue_free)
	pickupSoundPlayer.play()

func _on_timer_timeout():
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered():
	$Timer.stop()

func _on_visible_on_screen_notifier_2d_screen_exited():
	$Timer.start()
