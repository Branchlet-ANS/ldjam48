extends Camera2D

class_name MainCamera

const DEACCELERATION = 0.85
const STOP_THRESHOLD = 0.1
const CAMERA_SPEED = 200

var velocity = Vector2(0, 0)
var pos = Vector2(0, 0)
var target = Vector2(0, 0)

func _ready():
	zoom = Vector2(0.25, 0.25)

func _process(delta):
	var characters = get_parent().get_characters()
	var roomManager = get_parent().roomManager
	var god = get_parent().god
	var target = Vector2.ZERO
	if god.selected_characters.size() > 0:
		get_parent().get_node("GUI/Achievement").achievement("Select characters", "Now, take them for a walk.\nLeft click anywhere to command.")
		var max_dis = 0
		for character in god.selected_characters:
			target += character.get_position()
			for other in characters:
				max_dis = max(max_dis, (other.get_position() - character.get_position()).length())
		target /= god.selected_characters.size()
	elif characters.size() > 0:
		for character in characters:
			if character.tame:
				target = character.get_position()
				break
		
	var mouse_position = (get_viewport().get_mouse_position() - get_viewport().size/2) * zoom
	
	target += mouse_position / get_viewport().size.normalized() * 0.2
	
	if (roomManager.get_width() > get_viewport().size.x and roomManager.get_height() > get_viewport().size.y):
		var view_size = get_viewport().size * zoom
		var tx = clamp(target.x, - roomManager.get_width() / 2 + view_size.x / 2 - 16, + roomManager.get_width() / 2 - view_size.x / 2 + 16)
		var ty = clamp(target.y, - roomManager.get_height() / 2 + view_size.y / 2 - 16, + roomManager.get_height() / 2 - view_size.y / 2 + 16)
		target = Vector2(tx, ty)

	pos += (target - pos) * 0.05
	offset = pos
	
