extends Node

class_name Main

export var scene_character : Resource
export var scene_interactable : Resource

onready var god : God = $God
onready var roomManager : RoomManager = $RoomManager

var characters : Array = []
var interactables: Array = []

func _ready():
	
	add_character(100, 100)
	add_character(-100, -100)
	
#	var interactable = scene_interactable.instance()
#	add_child(interactable)
#	interactables.append(interactable)
	var room = Room.new(16, 16)
	room.basic_room()
	roomManager.add(room)
	roomManager.select(0)
	
func add_character(x : int, y : int):
	var character = scene_character.instance()
	character.transform.origin = Vector2(x, y)
	characters.append(character)
	add_child(character)

func get_interactables():
	var i = 0
	while i < interactables.size():
		if (!is_instance_valid(interactables[i])):
			interactables.erase(interactables[i])
			i -= 1
		i += 1
	return interactables
