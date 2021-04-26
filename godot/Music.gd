extends Node

class_name Music

var corruption = 0
var tracks = [preload("res://assets/music/theme_0.wav"),
	preload("res://assets/music/theme_1.wav"),
	preload("res://assets/music/theme_2.wav"),
	preload("res://assets/music/theme_3.wav")]

func _ready():
	play_music(0)
	pass

func _process(delta):
	pass

func play_music(corruption : int):
	print("play")
	var player : AudioStreamPlayer = AudioStreamPlayer.new()
	var sfx = tracks[min(floor(corruption/3),3)]
	sfx.set_stereo(true)
	player.set_stream(sfx)
	add_child(player)
	player.play()
	player.volume_db = -15

