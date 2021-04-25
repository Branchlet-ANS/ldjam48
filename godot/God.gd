extends Node2D

class_name God

var selected_characters : Array = []
var select_pos_start : Vector2 = Vector2.ZERO
var select_pressed = false
var character_space = 15
var clickable = null
var player_selected1 : AudioStreamPlayer2D
var sfx_selected1 = preload("res://Assets/SFX/selected1.wav")
var player_selected2 : AudioStreamPlayer2D
var sfx_selected2 = preload("res://Assets/SFX/selected2.wav")

func _ready():
	player_selected1 = AudioStreamPlayer2D.new()
	add_child(player_selected1)
	player_selected1.set_stream(sfx_selected1)
	player_selected2 = AudioStreamPlayer2D.new()
	add_child(player_selected2)
	player_selected2.set_stream(sfx_selected2)

func _unhandled_input(event):
	var mouse_pos = get_parent().camera.mouse_world_position()
	if event is InputEventMouseButton:
		if(event.get_button_index() == 1):
			if(event.is_pressed()):
				select_pos_start = mouse_pos
				select_pressed = true
			else:
				select_pressed = false
				var select_pos_end = mouse_pos
				if (select_pos_end - select_pos_start).length() < 12:
					var closest_character = get_closest(get_parent().characters, mouse_pos)
					if (closest_character.get_position() - mouse_pos).length() < 16:
						selected_characters = [closest_character]
						player_selected1.play()
						return
					var closest_monster = get_closest(get_parent().roomManager.get_monsters(), mouse_pos)
					if (closest_monster.get_position() - mouse_pos).length() < 16:
						contact(closest_monster)
						return
					var closest_interactable = get_closest(get_parent().roomManager.get_interactables(), mouse_pos)
					if (closest_interactable.get_position() - mouse_pos).length() < 16:
						interact(closest_interactable)
						return
					var n = selected_characters.size()

					get_parent().grid_entities(selected_characters, mouse_pos, character_space)
#					for i in range(n):
#						# Plasserer valgte karakterers i et kvadrat rundt musepekeren
#						selected_characters[i].set_job(null)
#						selected_characters[i].set_target(mouse_pos +
#						(fmod(i, float(floor(sqrt(n)))) -
#						fmod(n, float(floor(sqrt(n)))) ) * character_space * Vector2.RIGHT +
#						(float(i) / float(floor(sqrt(n))) -
#						float(n) / float(floor(sqrt(n))) ) * character_space * Vector2.UP)
					player_selected1.play()
				else:
					var new_selection = []
					for character in get_parent().characters:
						if(Rect2(min(select_pos_start.x, select_pos_end.x), # if character in mouse rect
								min(select_pos_start.y, select_pos_end.y),
								max(select_pos_start.x, select_pos_end.x) - min(select_pos_start.x, select_pos_end.x),
								max(select_pos_start.y, select_pos_end.y) - min(select_pos_start.y, select_pos_end.y)).intersects(
									Rect2(character.position, character.collision_shape.shape.get_extents()))):
							new_selection.append(character)
					if new_selection.size() > 0:
						selected_characters = new_selection
					if(new_selection.size() >= 2):
						player_selected2.play()
					elif(new_selection.size() >= 1):
						player_selected1.play()
		if(event.get_button_index() == 2):
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

static func get_closest(objects, position):
	assert(objects.size() >= 1)
	var closest = objects[0]
	for object in objects:
		if position.distance_to(object.get_position()) < position.distance_to(closest.get_position()):
			closest = object
	return closest

func interact(interactable):
	for character in selected_characters:
		character.set_job(interactable)

func contact(monster):
	for character in selected_characters:
		character.attack(monster)

func _process(_delta):
	update()

func _draw():
	var camera = get_parent().camera
	if select_pressed: # Tegn boks fra der musen ble trykt til der musen er nå
		var pos1 = select_pos_start
		var pos2 = camera.mouse_world_position()
		var points = PoolVector2Array([pos1, Vector2(pos1.x, pos2.y),
				pos2, Vector2(pos2.x, pos1.y)])
		draw_polygon(points, PoolColorArray([Color(0.7, 0.7, 0.7, 0.6)]))

	for character in get_parent().characters:
		if !is_instance_valid(character):
			get_parent().characters.erase(character)
		if character._health < 100:
			var pos = character.transform.origin
			var bg_points = PoolVector2Array([pos + Vector2(-10, -14), pos + Vector2(-10, -12), pos + Vector2(10, -12), pos + Vector2(10, -14)])
			var fg_points = PoolVector2Array([pos + Vector2(-10, -14), pos + Vector2(-10, -12), pos + Vector2(-10+character._health/5, -12), pos + Vector2(-10+character._health/5, -14)])
			draw_colored_polygon(bg_points, Color.darkred)
			draw_colored_polygon(fg_points, Color.red)

	for character in selected_characters:
		if !is_instance_valid(character):
			selected_characters.erase(character)
		var pos = character.transform.origin
		var points = PoolVector2Array([pos + Vector2(-5, -20), pos + Vector2(0, -15), pos + Vector2(5, -20)])
		draw_colored_polygon(points, Color.lightgreen)
	if is_instance_valid(clickable):
		var pos = clickable.transform.origin
		var points = PoolVector2Array([pos + Vector2(5, -20), pos + Vector2(-5, -20), pos + Vector2(0, -15)])
		draw_polygon(points, PoolColorArray([Color(0.7, 0.7, 0.7, 0.6)]))
