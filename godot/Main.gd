extends Node

class_name Main

export var scene_character : Resource

onready var god : God = $God
onready var roomManager : RoomManager = $RoomManager

var characters : Array = []
var interactables: Array = []

func _ready():
	var _r = Room.new(32, 18)
	_r.basic_room()
	roomManager.add(_r)
	roomManager.select(0)
	
	add_character(100, 100)
	add_character(-100, -100)
	add_character(100, 100)
	add_character(-100, -100)
	add_character(100, 100)
	add_character(-100, -100)
	add_character(100, 100)
	add_character(-100, -100)
	add_character(100, 100)
	add_character(-100, -100)
	add_character(100, 100)
	
	for object in roomManager.room_container.get_children():
		if object.get_id() == "o:room_entrance":
			for i in range(len(characters)):
				characters[i].set_position(object.get_position() + Vector2(16, 8) * i)
			break
			
	
func add_character(x : int, y : int):
	var character = scene_character.instance()
	character.transform.origin = Vector2(x, y)
	characters.append(character)
	roomManager.room_container.add_child(character)

func get_interactables():
	var i = 0
	while i < interactables.size():
		if (!is_instance_valid(interactables[i])):
			interactables.erase(interactables[i])
			i -= 1
		i += 1
	return interactables
