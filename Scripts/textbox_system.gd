extends Control

var text_pages = []
var page = 0

var finish_delay = 0
var finish = 1

const text_padding = 16

const text_pos = Vector2(16+text_padding, 832+text_padding)
const text_size = Vector2(1888-text_padding, 232-text_padding)

const text_name_pos = Vector2(16+text_padding, 888+text_padding)
const text_name_size = Vector2(1888-text_padding, 176-text_padding)

const text_nf_pos = Vector2(256+text_padding, 832+text_padding)
const text_nf_size = Vector2(1648-text_padding, 232-text_padding)

const name_pos = Vector2(8+text_padding, 816+text_padding)
const name_size = Vector2(240-text_padding, 40-text_padding)

func _ready():
	Global.textbox = self
	set_visible(false)
	EventDispatcher.return_to_main_menu.connect(has_gone_to_main_menu)

func get_text(Dictionary = null):
	if Dictionary != null:
		text_pages.append(Dictionary)
	else:
		if text_pages.is_empty():
			return
	
	set_visible(true)
	
	finish_delay = 0
	$TextureRect.set_visible(false)
	$TextLabel.visible_characters = 0
	$TextLabel.text = text_pages[page]["text"]
	if text_pages[page].has("name"):
		$NameLabel.text = text_pages[page]["name"]
	if text_pages[page].has("sound"):
		$TextSound.stream = text_pages[page]["sound"]
	$TypeTimer.wait_time = text_pages[page]["speed"]
	
	load_text()

func load_text():
	if text_pages[page].has("name"):
		$NameLabel.visible = true
		$NameLabel.position = name_pos
		$NameLabel.size = name_size
		$TextLabel.position = text_name_pos
		$TextLabel.size = text_name_size
	else:
		$NameLabel.visible = false
		$TextLabel.position = text_pos
		$TextLabel.size = text_size
	
	if !text_pages[page].has("sound"):
		$TextSound.stream = lib.textbox_sounds.get("text1")

func _process(delta):
	if visible == false or text_pages.is_empty():
		return
	
	if $TextLabel.visible_characters < text_pages[page]["text"].length():
		if $TypeTimer.is_stopped():
			$TypeTimer.start()
		
		if Input.is_action_just_pressed("ui_accept"):
			$TypeTimer.stop()
			$TextLabel.visible_characters = text_pages[page]["text"].length()
	else:
		if finish_delay < finish:
			finish_delay += 1*delta
		else:
			$TextureRect.set_visible(true)
			$TextureRect.position.y += sin(Global.global_time*10)
			
			if Input.is_action_just_pressed("ui_accept"):
				text_pages.remove_at(page)
				
				page +=1
				
				if page > text_pages.size()-1:
					page = 0
					set_visible(false)

func _on_type_timer_timeout():
	$TextSound.play()
	while $TextLabel.text.unicode_at($TextLabel.visible_characters) == 32:
		$TextLabel.visible_characters += 1
	
	$TextLabel.visible_characters += 1

func has_gone_to_main_menu():
	text_pages.clear()
	page = 0
	set_visible(false)
