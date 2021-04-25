extends Node2D

class_name God

var selected_characters : Array = []
var select_pos_start : Vector2 = Vector2.ZERO
var select_pressed = false
var character_space = 15
var clickable = null

func _unhandled_input(event):
	var mouse_pos = get_parent().camera.mouse_world_position()
	if event is InputEventMouseButton:
		if(event.get_button_index() == 1) and selected_characters.size() == 0:
			if(event.is_pressed()):
				select_pos_start = mouse_pos
				select_pressed = true
			else:
				selected_characters = []
				var select_pos_end = mouse_pos
				select_pressed = false
				update()
				var closest_character = get_closest(get_parent().characters, mouse_pos)
				if (closest_character.get_position() - mouse_pos).length() < 16:
					selected_characters = [closest_character]
				for character in get_parent().characters:
					if(Rect2(min(select_pos_start.x, select_pos_end.x), # if character in mouse rect
							min(select_pos_start.y, select_pos_end.y),
							max(select_pos_start.x, select_pos_end.x) - min(select_pos_start.x, select_pos_end.x),
							max(select_pos_start.y, select_pos_end.y) - min(select_pos_start.y, select_pos_end.y)).intersects(
								Rect2(character.position, character.collision_shape.shape.get_extents()))):
						selected_characters.append(character)
		elif(event.get_button_index() == 1):
			if !event.is_pressed():
				var closest_monster = get_closest(get_parent().roomManager.get_monsters(), mouse_pos)
				if (closest_monster.get_position() - mouse_pos).length() < 16:
					contact(closest_monster)
					return
				var closest_interactable = get_closest(get_parent().roomManager.get_interactables(), mouse_pos)
				if (closest_interactable.get_position() - mouse_pos).length() < 16:
					interact(closest_interactable)
					return
				var n = selected_characters.size()
				for i in range(n):
					# Plasserer valgte karakterers i et kvadrat rundt musepekeren
					selected_characters[i].set_target(mouse_pos +
					(fmod(i, float(floor(sqrt(n)))) -
					fmod(n, float(floor(sqrt(n)))) ) * character_space * Vector2.RIGHT +
					(float(i) / float(floor(sqrt(n))) -
					float(n) / float(floor(sqrt(n))) ) * character_space * Vector2.UP)
				selected_characters.clear()
		elif(event.get_button_index() == 3):
			for character in selected_characters:
				character.strike(mouse_pos)
	elif event is InputEventMouseMotion:
		var all = get_parent().roomManager.get_monsters() + get_parent().roomManager.get_interactables()
		var closest = get_closest(all, mouse_pos)
		if (closest.get_position() - mouse_pos).length() < 16:
			clickable = closest
		else:
			clickable = null
		update()

func get_closest(objects, position):
	assert(objects.size() >= 1)
	var closest = objects[0]
	for object in objects:
		if position.distance_to(object.get_position()) < position.distance_to(closest.get_position()):
			closest = object
	return closest

func interact(interactable):
	for character in selected_characters:
		character.set_job(interactable)
	selected_characters.clear()

func contact(monster):
	for character in selected_characters:
		character.attack(monster)
	selected_characters.clear()

func _process(_delta):
	if select_pressed or selected_characters.size() > 0:
		update()

func _draw():
	var camera = get_parent().camera
	if select_pressed: # Tegn boks fra der musen ble trykt til der musen er nå
		var pos1 = select_pos_start
		var pos2 = camera.mouse_world_position()
		var points = PoolVector2Array([pos1, Vector2(pos1.x, pos2.y),
				pos2, Vector2(pos2.x, pos1.y)])
		draw_polygon(points, PoolColorArray([Color(0.7, 0.7, 0.7, 0.6)]))
	for character in selected_characters:
		var pos = character.transform.origin
		if character._health < 100:
			var bg_points = PoolVector2Array([pos + Vector2(-10, -20), pos + Vector2(-10, -17), pos + Vector2(10, -17), pos + Vector2(10, -20)])
			var fg_points = PoolVector2Array([pos + Vector2(-10, -20), pos + Vector2(-10, -17), pos + Vector2(-10+character._health/5, -17), pos + Vector2(-10+character._health/5, -20)])
			draw_colored_polygon(bg_points, Color.darkred)
			draw_colored_polygon(fg_points, Color.red)
		else:
			var points = PoolVector2Array([pos + Vector2(-5, -20), pos + Vector2(0, -15), pos + Vector2(5, -20)])
			draw_colored_polygon(points, Color.lightgreen)
	if clickable != null:
		var pos = clickable.transform.origin
		var points = PoolVector2Array([pos + Vector2(5, -20), pos + Vector2(-5, -20), pos + Vector2(0, -15)])
		draw_polygon(points, PoolColorArray([Color(0.7, 0.7, 0.7, 0.6)]))
