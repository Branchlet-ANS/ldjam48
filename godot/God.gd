extends Node2D

class_name God

onready var camera = $"../Camera2D"

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
				update()
				for character in get_parent().characters:
					if(Rect2(min(select_pos_start.x, select_pos_end.x), # if character in mouse rect
							min(select_pos_start.y, select_pos_end.y),
							max(select_pos_start.x, select_pos_end.x) - min(select_pos_start.x, select_pos_end.x),
							max(select_pos_start.y, select_pos_end.y) - min(select_pos_start.y, select_pos_end.y)).intersects(
								Rect2(character.position, character.collision_shape.shape.get_extents()))):
						selected_characters.append(character)
		
		elif(event.get_button_index() == 2):
			for character in selected_characters:
				character.target = event.position - get_viewport_rect().size/2
			

func _process(delta):
	if(select_pressed):
		update() #kaller _draw()
	
	if Input.is_action_pressed("ui_left"):
		camera.spd_x = -5
	if Input.is_action_pressed("ui_right"):
		camera.spd_x = 5
	if Input.is_action_pressed("ui_up"):
		camera.spd_y = -5
	if Input.is_action_pressed("ui_down"):
		camera.spd_y = 5
	

func _draw():
	if(select_pressed): # Tegn boks fra der musen ble trykt til der musen er nå
		var pos1 = select_pos_start
		var pos2 = get_viewport().get_mouse_position() - get_viewport_rect().size/2
		var points = PoolVector2Array([pos1, Vector2(pos1.x, pos2.y),
				pos2, Vector2(pos2.x, pos1.y)])
		draw_polygon(points, PoolColorArray([Color(0.7, 0.7, 0.7, 0.6)]))
