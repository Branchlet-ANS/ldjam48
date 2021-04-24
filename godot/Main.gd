extends Node

class_name Main

onready var scene_gatherable = preload("res://Gatherable.tscn")
onready var scene_character = preload("res://Character.tscn")
onready var god : God = $God

var characters : Array = []
var interactables: Array = []

func _ready():
#	var item = scene_gatherable.instance()
#	item.transform.origin = Vector2(100, 100)
#	add_child(item)
	add_character(0, 0)
	add_character(-100, -100)


func add_character(x : int, y : int) -> Character:
	var character = scene_character.instance()
	character.transform.origin = Vector2(x, y)
	characters.append(character)
	add_child(character)
	return character
