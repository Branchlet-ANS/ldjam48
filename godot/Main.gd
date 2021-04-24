extends Node

class_name Main

onready var scene_gatherable = preload("res://Gatherable.tscn")
onready var scene_character = preload("res://Character.tscn")
onready var scene_interactable = preload("res://InteractableTest.tscn")

onready var god : God = $God


var characters : Array = []
var interactables: Array = []

func _ready():
#	var item = scene_gatherable.instance()
#	item.transform.origin = Vector2(100, 100)
#	add_child(item)
	add_character(100, 100)
	add_character(-100, -100)
	var interactable = scene_interactable.instance()
	add_child(interactable)
	interactables.append(interactable)

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
