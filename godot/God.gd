extends Node2D

class_name God

onready var camera = $Camera2D

var selected_characters : Array = []

func _unhandled_input(event):
	if event is InputEventMouseButton:
		for character in selected_characters:
			character.target = event.position - get_viewport_rect().size/2
			
