extends Node

class_name Music

var corruption = 0
var tracks = [preload("res://assets/music/theme_0.wav"),
	preload("res://assets/music/theme_1.wav"),
	preload("res://assets/music/theme_2.wav"),
	preload("res://assets/music/theme_3.wav")]
var player : AudioStreamPlayer

func _ready():
	player = AudioStreamPlayer.new()
	add_child(player)
	player.volume_db = -20
	pass

func _process(delta):
	pass

func play_music(corruption : int):
	var sfx = tracks[min(floor(corruption/3),3)]
	sfx.set_stereo(true)
	player.set_stream(sfx)
	player.play()

