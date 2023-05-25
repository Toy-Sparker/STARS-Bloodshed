extends CharacterBody2D

enum player_states {
	default
}

var state = player_states.default
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

var character : Object

func _ready():
	EventDispatcher.player_entered.emit(self)
	EventDispatcher.player_level_up.connect(level_up)
	Global.player_node = self
	
	load_character(Global.player_character)

func load_character(_character):
	match(_character):
		"jack":
			character = load("res://Scenes/Characters/character_jack.tscn")
			add_child(character.instantiate())
			
			var _weapon = load("res://Scenes/Weapons/weapon_revolver.tscn")
			get_node("Weapons").add_child(_weapon.instantiate())
			
			Global.textbox.get_text({
				"text": "Time to kick ass.",
				"speed": 0.05,
				"name": "Jack"
			})
		"lumen":
			character = load("res://Scenes/Characters/character_lumen.tscn")
			add_child(character.instantiate())
			
			var _weapon = load("res://Scenes/Weapons/weapon_sickles.tscn")
			get_node("Weapons").add_child(_weapon.instantiate())
			
			Global.textbox.get_text({
				"text": "Get ready to suck my dick!",
				"speed": 0.05,
				"name": "Lumen",
				"sound": lib.textbox_sounds.get("lumen")
			})
		_:
			character = load("res://Scenes/Characters/character_base.tscn")
			add_child(character.instantiate())
			
			var _weapon = load("res://Scenes/Weapons/weapon_gun.tscn")
			get_node("Weapons").add_child(_weapon.instantiate())
			
			Global.textbox.get_text({
				"text": "Ready to go.",
				"speed": 0.05
			})

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
		EventDispatcher.player_died.emit()
		queue_free()

func _on_flash_timer_timeout():
	character.get_node("Sprite").material.set_shader_parameter("flash_modifier", 0)

func collect_box(area):
	area.play_sound(area.current_sound, area.pickup_pitch)
	
	current_exp += area.exp_amount
	total_exp += area.exp_amount
	
	hp = min(hp + area.heal, max_hp)
	
	if current_exp >= next_level_exp:
		$LevelupSound.play()
		level += 1
		current_exp -= next_level_exp
		next_level_exp = pow(start_exp, level)
		
		hp = min(hp + level, max_hp)
		
		EventDispatcher.player_level_up.emit(level)
	
	area.queue_free()

func level_up(level):
	character.max_hp = max_hp
