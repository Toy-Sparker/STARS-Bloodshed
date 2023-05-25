extends Control

var min_value = -48
var max_value = 0
var has_menu_exit = true

func _ready():
	$SndSlider.value = Global.snd_vol
	$MusSlider.value = Global.mus_vol
	
	$SndSlider.min_value = min_value
	$MusSlider.min_value = min_value
	
	$SndSlider.max_value = max_value
	$MusSlider.max_value = max_value
	
	if !has_menu_exit:
		$MainMenuButton.pressed.disconnect(_on_main_menu_button_pressed)
		$MainMenuButton.text = "Close Menu"
		$MainMenuButton.pressed.connect(_close_menu_button_pressed)

func _on_mus_slider_value_changed(value):
	Global.mus_vol = value
	
	AudioServer.set_bus_volume_db(1, value)

func _on_snd_slider_value_changed(value):
	Global.snd_vol = value
	
	AudioServer.set_bus_volume_db(2, value)

func _close_menu_button_pressed():
	$MainMenuButton.pressed.disconnect(_close_menu_button_pressed)
	queue_free()

func _on_main_menu_button_pressed():
	get_tree().paused = false
	EventDispatcher.game_pause.emit(false)
	EventDispatcher.return_to_main_menu.emit()
