extends Node2D

class_name God

var selected_characters : Array = []
var select_pos_start : Vector2 = Vector2.ZERO
var select_pressed = false
var character_space = 15

func _unhandled_input(event):
	if event is InputEventMouseButton:
		var camera = get_parent().camera
		if(event.get_button_index() == 2):
			if(event.is_pressed()):
				select_pos_start = camera.mouse_world_position()
				select_pressed = true
			else:
				selected_characters = []
				var select_pos_end = camera.mouse_world_position()
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
			var n = selected_characters.size()
			for i in range(n):
				var wpos = camera.mouse_world_position() # Plasserer valgte karakterers i et kvadrat rundt musepekeren
				selected_characters[i].set_target(camera.mouse_world_position() +
				(fmod(i, float(floor(sqrt(n)))) -
				fmod(n, float(floor(sqrt(n)))) ) * character_space * Vector2.RIGHT +
				(float(i) / float(floor(sqrt(n))) -
				float(n) / float(floor(sqrt(n))) ) * character_space * Vector2.UP)

func interact(interactable):
	for character in selected_characters:
		character.add_job(interactable)

func _process(_delta):
	if select_pressed or selected_characters.size() > 0:
		update()
	var camera = get_parent().camera
	if Input.is_action_pressed("ui_left"):
		camera.spd_x = -camera.CAMERA_SPEED
	if Input.is_action_pressed("ui_right"):
		camera.spd_x = camera.CAMERA_SPEED
	if Input.is_action_pressed("ui_up"):
		camera.spd_y = -camera.CAMERA_SPEED
	if Input.is_action_pressed("ui_down"):
		camera.spd_y = camera.CAMERA_SPEED


func _draw():
	var camera = get_parent().camera
	if(select_pressed): # Tegn boks fra der musen ble trykt til der musen er nå
		var pos1 = select_pos_start
		var pos2 = camera.mouse_world_position()
		var points = PoolVector2Array([pos1, Vector2(pos1.x, pos2.y),
				pos2, Vector2(pos2.x, pos1.y)])
		draw_polygon(points, PoolColorArray([Color(0.7, 0.7, 0.7, 0.6)]))
	for character in selected_characters:
		var pos = character.transform.origin
		var points = PoolVector2Array([pos + Vector2(5, -20), pos + Vector2(-5, -20), pos + Vector2(0, -15)])
		draw_polygon(points, PoolColorArray([Color(0.7, 0.7, 0.7, 0.6)]))
