extends Node

class_name Main

export var scene_character : Resource
export var scene_projectile : Resource
export var scene_interactable : Resource

onready var god : God = $God
onready var roomManager : RoomManager = $RoomManager

var characters : Array = []
var interactables: Array = []

func _ready():
	for i in range(10):
		add_character(i*100, i*100)
	
#	var interactable = scene_interactable.instance()
#	add_child(interactable)
#	interactables.append(interactable)
	var room = Room.new(16, 16)
	room.basic_room()
	roomManager.add(room)
	roomManager.select(0)
	for object in roomManager.room_container.get_children():
		if object.get_id() == "o:room_entrance":
			for i in range(len(characters)):
				characters[i].set_position(object.get_position() + Vector2(16, 8) * i)
			break
	
func add_character(x : int, y : int):
	var character = scene_character.instance()
	character.scene_projectile = scene_projectile
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
