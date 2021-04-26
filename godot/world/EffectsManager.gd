extends Node

class_name EffectsManager

func _ready():
	pass

static func play_sound(sound_name : String, sound_parent : Node, sound_position : Vector2):
	print(sound_name)
	var sfx = load("res://Assets/SFX/"+ sound_name + ".wav")
	sfx.set_stereo(true)
	var player : AudioStreamPlayer2D = AudioTimer.new(sfx.get_length())
	sound_parent.add_child(player)
	player.position = sound_position
	player.set_stream(sfx)
	player.play()
