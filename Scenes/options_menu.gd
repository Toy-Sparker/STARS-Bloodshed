extends Control

var min_value = -48
var max_value = 0

func _ready():
	$SndSlider.value = Global.snd_vol
	$MusSlider.value = Global.mus_vol
	
	$SndSlider.min_value = min_value
	$MusSlider.min_value = min_value
	
	$SndSlider.max_value = max_value
	$MusSlider.max_value = max_value

func _on_mus_slider_value_changed(value):
	Global.mus_vol = value
	
	AudioServer.set_bus_volume_db(1, value)

func _on_snd_slider_value_changed(value):
	Global.snd_vol = value
	
	AudioServer.set_bus_volume_db(2, value)

func _on_main_menu_button_pressed():
	EventDispatcher.return_to_main_menu.emit()
