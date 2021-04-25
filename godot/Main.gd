extends Node

class_name Main

onready var god : God = $God
var roomManager : RoomManager
var camera : MainCamera

var characters : Array = []

func _ready():
	randomize() # butterfly effect
	camera = MainCamera.new()
	add_child(camera)
	camera.current = true
	roomManager = RoomManager.new()
	add_child(roomManager)
	roomManager.set_tileset(load("res://world/tileset.tres"))

	var _r = Room.new(32, 18)
	_r.basic_room()
	roomManager.add(_r)
	roomManager.select(0)

	for i in range(10):
		add_character(i*100, i*100)

	for object in roomManager.room_container.get_children():
		if object.get_id() == "o:room_entrance":
			for i in range(len(characters)):
				characters[i].set_position(object.get_position() + Vector2(16, 8) * i)
			break

	god = God.new()
	add_child(god)


func add_character(x : int, y : int):
	var character = Character.new("character")
	roomManager.room_container.add_child(character)
	character.transform.origin = Vector2(x, y)
	characters.append(character)
