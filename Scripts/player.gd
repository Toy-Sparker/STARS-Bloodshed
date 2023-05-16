extends CharacterBody2D

var is_ready = false

var speed = 8000.0

var axis = Vector2()
var aim_vector = Vector2.RIGHT
var direction = Vector2.RIGHT

var max_hp = 5
var hp = max_hp

var level = 1
var total_exp = 0
var current_exp = 0
var start_exp = 3
var next_level_exp = pow(start_exp, level)

var character : Object = null

func _ready():
	Global.player_node = self
	EventDispatcher.player_level_up.connect(level_up)
	
	load_character("jack")

func load_character(_character):
	match(_character):
		"jack":
			var character = load("res://Scenes/Characters/character_jack.tscn")
			add_child(character.instantiate())
			
			var _weapon = load("res://Scenes/Weapons/weapon_revolver.tscn")
			get_node("Weapons").add_child(_weapon.instantiate())
		"base":
			var character = load("res://Scenes/Characters/character_base.tscn")
			add_child(character.instantiate())
			
			var _weapon = load("res://Scenes/Weapons/weapon_gun.tscn")
			get_node("Weapons").add_child(_weapon.instantiate())

func update_exp_ui():
	Global.canvas_node.get_node("UI/EXPBar").max_value = next_level_exp
	Global.canvas_node.get_node("UI/EXPBar").value = current_exp
	
	Global.canvas_node.get_node("UI/EXPBar/LvlLabel").text = "Lv " + str(level) + ", XP needed: " + str(next_level_exp)

func _process(_delta):
	$HPBar.max_value = max_hp
	$HPBar.value = hp
	
	update_exp_ui()
	
	aim_vector.x = Input.get_axis("aim_left", "aim_right")
	aim_vector.y = Input.get_axis("aim_up", "aim_down")
	aim_vector.normalized()
	
	if aim_vector != Vector2.ZERO:
		direction = aim_vector
	
	get_node("Weapons").get_child(0).direction = direction

func flash():
	character.get_node("Sprite").material.set_shader_parameter("flash_modifier", 1)
	$FlashTimer.start()

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	axis.x = Input.get_axis("ui_left", "ui_right")
	axis.y = Input.get_axis("ui_up", "ui_down")
	axis.normalized()
	
	velocity.x = axis.x * speed
	velocity.y = axis.y * speed
	velocity = velocity * delta
	move_and_slide()

func got_hurt():
	hp -= 1
	
	flash()
	
	if hp <= 0:
		queue_free()

func _on_flash_timer_timeout():
	character.get_node("Sprite").material.set_shader_parameter("flash_modifier", 0)

func collect_box(area):
	$PickupSound.pitch_scale = area.pickup_pitch
	$PickupSound.play()
	
	current_exp += area.exp_amount
	total_exp += area.exp_amount
	
	if current_exp >= next_level_exp:
		$LevelupSound.play()
		level += 1
		current_exp -= next_level_exp
		next_level_exp = pow(start_exp, level)
		
		if hp < max_hp:
			hp += 1
		
		EventDispatcher.player_level_up.emit(level)
	
	area.queue_free()

func level_up(level):
	pass
