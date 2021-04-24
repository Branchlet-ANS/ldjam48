extends Node2D

func _ready():
	pass # Replace with function

func set_color(_color):
	$ColorRect.color = _color

func set_size(size):
	scale = Vector2(size/17, size/17)
