extends Control

var text_pages = []
var page = 0

var text_dict : Dictionary = {
	"text": "Hello world! How are you today?",
	"speed": 0.05,
	"sound": ""
}

var finish_delay = 0
var finish = 1

func _ready():
	text_pages.append(text_dict)
	get_text_dict()

func get_text_dict():
	text_dict = text_pages[page].duplicate()
	
	finish_delay = 0
	$TextureRect.set_visible(false)
	$TextLabel.visible_characters = 0
	$TextLabel.text = text_dict["text"]
	$TypeTimer.wait_time = text_dict["speed"]

func _process(delta):
	if visible == false:
		return
	
	if $TextLabel.visible_characters < text_dict["text"].length():
		if $TypeTimer.is_stopped():
			$TypeTimer.start()
	else:
		if finish_delay < finish:
			finish_delay += 1*delta
		else:
			$TextureRect.set_visible(true)
			
			if Input.is_action_just_pressed("ui_accept"):
				page +=1
				
				if page > text_pages.size()-1:
					set_visible(false)

func _on_type_timer_timeout():
	$TextSound.play()
	while $TextLabel.text.unicode_at($TextLabel.visible_characters) == 32:
		$TextLabel.visible_characters += 1
	
	$TextLabel.visible_characters += 1
