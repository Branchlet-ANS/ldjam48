extends AudioStreamPlayer2D

class_name AudioTimer

var _death_timer : int = 1

func _init(death_timer : int = 1):
	_death_timer = death_timer

func _ready():
	pass

func _process(delta):
	_death_timer -= delta
	if(_death_timer < 0):
		queue_free()
