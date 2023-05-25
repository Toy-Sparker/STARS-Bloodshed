extends Node

var music = {
	"menu": preload("res://Music/STARS Bloodshed - Menu.mp3"),
	"level1": preload("res://Music/STARS Bloodshed - Level 1.mp3")
}

var player_sounds = {
	"levelup": preload("res://Sound/Powerup4.wav"),
	"death": preload("res://Sound/STARSBLOODSHED_gameover.wav")
}

var textbox_sounds = {
	"text1": preload("res://Sound/STARSBLOODSHED_text1.wav"),
	"lumen": preload("res://Sound/STARSBLOODSHED_text_lumen.wav")
}

var exp_sounds = {
	"point1": preload("res://Sound/Pickup_Coin.wav"),
	"point2": preload("res://Sound/STARSBLOODSHED_pickup2.wav")
}

var enemy_sounds = {
	"hurt": preload("res://Sound/Hit_Hurt2.wav"),
	"death": preload("res://Sound/Explosion3.wav")
}

var enemy_scenes = {
	"enemy_basic": preload("res://Scenes/Enemies/enemy.tscn"),
	"enemy_strong": preload("res://Scenes/Enemies/enemy_strong.tscn"),
	"enemy_boss": preload("res://Scenes/Enemies/enemy_boss.tscn")
}

var enemy_explode_scene = preload("res://Scenes/Enemies/enemy_explode.tscn")
