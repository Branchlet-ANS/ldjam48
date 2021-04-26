extends Node2D

class_name God
var selected_characters : Array = []
var select_pos_start : Vector2 = Vector2.ZERO
var select_pressed = false
var character_space = 15
var clickable = null
var left_down = false
var dead = false
var texture : Texture

func _ready():
	pass

func _unhandled_input(event):
	var mouse_pos = get_global_mouse_position()
	if event is InputEventMouseButton:
		if event.get_button_index() == 1:
			if !event.is_pressed():
				left_down = false
				var closest_monster = get_closest(get_parent().roomManager.get_enemies(), mouse_pos)
				if closest_monster != null and (closest_monster.get_position() - mouse_pos).length() < 16:
					contact(closest_monster)
					return
				var closest_interactable = get_closest(get_parent().roomManager.get_interactables(), mouse_pos)
				if (closest_interactable.get_position() - mouse_pos).length() < 16:
					var closest_fella = get_closest(selected_characters, mouse_pos)
					for fella in selected_characters:
						if !(fella == closest_fella):
							fella.set_state(fella.STATE.idle)
					interact(closest_fella, closest_interactable)
					return
			else:
				left_down = true
				set_selection_target()
		elif event.get_button_index() == 2:
			if(event.is_pressed()):
				select_pos_start = mouse_pos
				select_pressed = true
			else:
				select_pressed = false
				var select_pos_end = mouse_pos
				if (select_pos_end - select_pos_start).length() < 12:
					var closest_character = get_closest(get_parent().get_characters(), mouse_pos)
					if closest_character != null:
						if (closest_character.get_position() - mouse_pos).length() < 16:
							selected_characters = [closest_character]
							closest_character.tame = true
							EffectsManager.play_sound("selected2", self, position)
							return
						else:
							selected_characters.clear()
				else:
					var new_selection = []
					for character in get_parent().get_characters():
						if(Rect2(min(select_pos_start.x, select_pos_end.x), # if character in mouse rect
								min(select_pos_start.y, select_pos_end.y),
								max(select_pos_start.x, select_pos_end.x) - min(select_pos_start.x, select_pos_end.x),
								max(select_pos_start.y, select_pos_end.y) - min(select_pos_start.y, select_pos_end.y)).intersects(
									Rect2(character.position, character.collision_shape.shape.get_extents()))):
							new_selection.append(character)
							character.tame = true
					selected_characters = new_selection
					if(new_selection.size() >= 2):
						EffectsManager.play_sound("selected2", self, position)
					elif(new_selection.size() >= 1):
						EffectsManager.play_sound("selected1", self, position)
	elif event is InputEventMouseMotion:
		var all = get_parent().roomManager.get_enemies() + get_parent().roomManager.get_interactables() + get_parent().roomManager.get_characters()
		var closest = get_closest(all, mouse_pos)
		if (closest.get_position() - mouse_pos).length() < 16:
			clickable = closest
		else:
			clickable = null
		update()

static func get_closest(objects, position):
	if objects.size() == 0:
		return null
	var closest = objects[0]
	for object in objects:
		if position.distance_to(object.get_position()) < position.distance_to(closest.get_position()):
			closest = object
	return closest

func set_selection_target():
	var mouse_pos = get_global_mouse_position()
	for character in selected_characters:
		character.set_job(null)
		character.set_state(character.STATE.idle)
	grid_entities(selected_characters, mouse_pos, character_space)

func interact(character, interactable):
	if is_instance_valid(character):
		character.set_job(interactable)

func contact(monster):
	for character in selected_characters:
		character.attack(monster)

func _process(_delta):
	var character_size = 0
	for character in get_parent().get_characters():
		if(is_instance_valid(character) and character.tame):
			character_size+=1
	if(character_size<= 0):
		if(!dead):
			get_parent().get_node("GUI/Achievement").achievement("You died", "You'll forever be a part of the jungle")
			dead = true
			yield(get_tree().create_timer(3.0), "timeout")
			get_tree().reload_current_scene()
			
	if left_down:
		set_selection_target()
	update()

func _draw():
	var camera = get_parent().camera
	if select_pressed: # Tegn boks fra der musen ble trykt til der musen er nå
		var pos1 = select_pos_start
		var pos2 = get_global_mouse_position()
		var points = PoolVector2Array([pos1, Vector2(pos1.x, pos2.y),
				pos2, Vector2(pos2.x, pos1.y)])
		draw_polygon(points, PoolColorArray([Color(0.7, 0.7, 0.7, 0.6)]))
	
	for enemy in get_parent().roomManager.get_enemies():
		draw_healthbar(enemy, -16) 
	
	for character in selected_characters:
		if !is_instance_valid(character):
			selected_characters.erase(character)
		var pos = character.transform.origin
		var points = PoolVector2Array([pos + Vector2(-5, -25), pos + Vector2(0, -20), pos + Vector2(5, -25)])
		draw_colored_polygon(points, Color.lightgreen)
		
	if is_instance_valid(clickable):
		var pos = clickable.transform.origin
		if clickable is Character:
			var weapon_name = clickable.weapon.get_weapon_name().to_lower()
			if weapon_name != "fists":
				pos += Vector2.UP * 35
				texture = load("res://assets/items/" + weapon_name + ".png")
				var points = PoolVector2Array([pos + Vector2(-10, -10), pos + Vector2(10, -10), pos + Vector2(10, 10), pos + Vector2(-10, 10)])
				draw_colored_polygon(points, Color.lightgreen)
				draw_texture(texture, pos + Vector2(-8, -8))
		else:	
			var points = PoolVector2Array([pos + Vector2(-5, -20), pos + Vector2(0, -15), pos + Vector2(5, -20)])
			draw_colored_polygon(points, Color.lightgreen)
	
	for character in get_parent().get_characters():
		draw_healthbar(character, -25)
		
func draw_healthbar(character, offset):
	if character._health < 100:
		var pos = character.transform.origin
		var bg_points = PoolVector2Array([pos + Vector2(-10, offset-2), pos + Vector2(-10, offset), pos + Vector2(10, offset), pos + Vector2(10, offset-2)])
		var fg_points = PoolVector2Array([pos + Vector2(-10, offset-2), pos + Vector2(-10, offset), pos + Vector2(-10+character._health/5, offset), pos + Vector2(-10+character._health/5, offset-2)])
		draw_colored_polygon(bg_points, Color.darkred)
		draw_colored_polygon(fg_points, Color.red)

static func grid_entities(entities, around_position : Vector2, character_space):
	var n = float(entities.size())
	for i in range(n):
		entities[i].set_target(around_position #- Vector2(character_space*sqrt(n)/2, character_space*sqrt(n)/2) +
		+
		(fmod(i, sqrt(n)) - clamp(((n - floor(i / sqrt(n))*sqrt(n))), 0, sqrt(n))/2 ) * character_space * Vector2.LEFT +
		(floor(i / sqrt(n)) - sqrt(n)/2) * character_space * Vector2.UP)
