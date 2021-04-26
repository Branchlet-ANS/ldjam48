extends Node

class_name EffectsManager

func _ready():
	pass

static func play_sound(sound_name : String, sound_parent : Node, sound_position : Vector2):
	var sfx = load("res://Assets/SFX/"+ sound_name + ".wav")
	sfx.set_stereo(true)
	var player : AudioTimer = AudioTimer.new(sfx.get_length())
	sound_parent.add_child(player)
	player.position = sound_position
	player.set_stream(sfx)
	player.play()

static func play_video(video_name : String, video_parent : Node, video_position : Vector2):
	var vfx = load("res://Assets/VFX/"+ video_name + ".tres")
	var player : VideoTimer = VideoTimer.new(vfx.get_length())
	video_parent.add_child(player)
	player.position = video_position
