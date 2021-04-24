extends Node2D

class_name God

onready var camera = $Camera2D

var selected_characters : Array = []
var select_pos_start : Vector2 = Vector2.ZERO
var select_pressed = false

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if(event.get_button_index() == 1):
			if(event.is_pressed()):
				select_pos_start = event.get_position() - get_viewport_rect().size/2
				select_pressed = true
			else:
				selected_characters = []
				var select_pos_end = event.get_position() - get_viewport_rect().size/2
				select_pressed = false
				for character in get_parent().characters:
					if(Rect2(min(select_pos_start.x, select_pos_end.x), # if character in mouse rect
							min(select_pos_start.y, select_pos_end.y),
							max(select_pos_start.x, select_pos_end.x) - min(select_pos_start.x, select_pos_end.x),
							max(select_pos_start.y, select_pos_end.y) - min(select_pos_start.y, select_pos_end.y)).has_point(character.position)):
						selected_characters.append(character)
		
		elif(event.get_button_index() == 2):
			for character in selected_characters:
				character.target = event.position - get_viewport_rect().size/2


