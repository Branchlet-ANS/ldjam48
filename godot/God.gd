extends Node2D

class_name God

onready var camera = $"../Camera2D"

var selected_characters : Array = []
var select_pos_start : Vector2 = Vector2.ZERO
var select_pressed = false

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if(event.get_button_index() == 2):
			if(event.is_pressed()):
				select_pos_start = camera.screen_position(event)
				select_pressed = true
			else:
				selected_characters = []
				var select_pos_end = camera.screen_position(event)
				select_pressed = false
				update()
				for character in get_parent().characters:
					if(Rect2(min(select_pos_start.x, select_pos_end.x), # if character in mouse rect
							min(select_pos_start.y, select_pos_end.y),
							max(select_pos_start.x, select_pos_end.x) - min(select_pos_start.x, select_pos_end.x),
							max(select_pos_start.y, select_pos_end.y) - min(select_pos_start.y, select_pos_end.y)).intersects(
								Rect2(character.position, character.collision_shape.shape.get_extents()))):
						selected_characters.append(character)
		elif(event.get_button_index() == 1):
			for interactable in get_parent().get_interactables():
				if (interactable.transform.origin - camera.screen_position(event)).length() < 16:
					interact(interactable)
					return
			for character in selected_characters:
				character.target = camera.screen_position(event)
				character.set_state(character.STATE.target)
				
func interact(interactable):
	for character in get_parent().characters:
		character.add_job(interactable)
		
func _process(delta):
	if select_pressed or selected_characters.size() > 0:
		update()
	
	if Input.is_action_pressed("ui_left"):
		camera.spd_x = -camera.CAMERA_SPEED
	if Input.is_action_pressed("ui_right"):
		camera.spd_x = camera.CAMERA_SPEED
	if Input.is_action_pressed("ui_up"):
		camera.spd_y = -camera.CAMERA_SPEED
	if Input.is_action_pressed("ui_down"):
		camera.spd_y = camera.CAMERA_SPEED
	
	
func _draw():
	if(select_pressed): # Tegn boks fra der musen ble trykt til der musen er nå
		var pos1 = select_pos_start
		var pos2 = get_viewport().get_mouse_position() - get_viewport_rect().size/2 + camera.offset
		var points = PoolVector2Array([pos1, Vector2(pos1.x, pos2.y),
				pos2, Vector2(pos2.x, pos1.y)])
		draw_polygon(points, PoolColorArray([Color(0.7, 0.7, 0.7, 0.6)]))
	for character in selected_characters:
		var pos = character.transform.origin
		var points = PoolVector2Array([pos + Vector2(5, -20), pos + Vector2(-5, -20), pos + Vector2(0, -15)])
		draw_polygon(points, PoolColorArray([Color(0.7, 0.7, 0.7, 0.6)]))
