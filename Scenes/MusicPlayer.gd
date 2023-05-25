extends AudioStreamPlayer

func _ready():
	EventDispatcher.game_pause.connect(game_is_paused)
	EventDispatcher.level_load.connect(level_has_loaded)
	EventDispatcher.return_to_main_menu.connect(has_gone_to_main_menu)

func game_is_paused(bool):
	if bool:
		var getAudioEffect = AudioEffectFilter.new()
		getAudioEffect.cutoff_hz = 500
		AudioServer.set_bus_effect_enabled(1, 0, true)
	else:
		AudioServer.set_bus_effect_enabled(1, 0, false)

func level_has_loaded(level):
	match(level):
		"Level1":
			load_and_play(lib.music["level1"])

func has_gone_to_main_menu():
	stop()
	load_and_play(lib.music["menu"])

func load_and_play(track):
	stream = track
	play()
