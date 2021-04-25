extends Node

class_name Main

onready var god : God
var roomManager : RoomManager
var camera : MainCamera


var character_space = 15
var characters : Array = []


static func grid_entities(entities, around_position : Vector2, character_space):
	var n = float(entities.size())
	for i in range(n):
		entities[i].set_target(around_position +
		(fmod(i, float(floor(sqrt(n)))) -
		fmod(n, float(floor(sqrt(n)))) ) * character_space * Vector2.RIGHT +
		(float(i) / float(floor(sqrt(n))) -
		float(n) / float(floor(sqrt(n))) ) * character_space * Vector2.UP)

func _ready():
	randomize() # butterfly effect
	camera = MainCamera.new()
	add_child(camera)
	camera.current = true
	roomManager = RoomManager.new()
	add_child(roomManager)
	roomManager.set_tileset(load("res://world/tileset.tres"))
	var _room
	for i in range(32):
		_room = Room.new(randi() % 32 + 32, randi() % 46 + 32, i)
		var r = randi() % 3
		if r == 0:
			_room.monster_room()
		elif r == 1:
			_room.foraging_room()
		else:
			_room.bland_room()	
		roomManager.add(_room)
	roomManager.select(0)

	for i in range(10):
		add_character(0, 0)
	roomManager.rebuild()
	
	god = God.new()
	add_child(god)


func add_character(x : int, y : int):
	var character = Character.new("character")
	roomManager.room_container.add_child(character)
	character.transform.origin = Vector2(x, y)
	characters.append(character)

func _process(_delta):
	var target = Vector2.ZERO
	if god.selected_characters.size() > 0:
		var max_dis = 0
		for character in god.selected_characters:
			target += character.get_position()
			for other in characters:
				max_dis = max(max_dis, (other.get_position() - character.get_position()).length())
		target /= god.selected_characters.size()
	elif characters.size() > 0:
		var character = God.get_closest(characters, camera.get_position())
		target = character.get_position()
	target += camera.mouse_world_position() / get_viewport().size.normalized() * 0.2
	target /= 1.2
	var view_size = get_viewport().size * camera.zoom
	var tx = clamp(target.x, - roomManager.get_width() / 2 + view_size.x / 2 - 16, + roomManager.get_width() / 2 - view_size.x / 2 + 16)
	var ty = clamp(target.y, - roomManager.get_height() / 2 + view_size.y / 2 - 16, + roomManager.get_height() / 2 - view_size.y / 2 + 16)
	camera.target = Vector2(tx, ty)
	#var scale = sqrt(clamp(max_dis, 150, min(roomManager.get_width(), roomManager.get_height()))) / 50
	#camera.zoom = Vector2(scale, scale)
	
