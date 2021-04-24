extends Node

class_name Main

onready var scene_item = preload("res://Item.tscn")
onready var script_item = preload("res://Item.gd")
onready var scene_character = preload("res://Character.tscn")
onready var god : God = $God
var characters : Array = []

func _ready():
	var item = scene_item.instance()
	item.transform.origin = Vector2(100, 100)
	add_child(item)
	
	add_character()
	
func add_character() -> Character:
	var character = scene_character.instance()
	characters.append(character)
	add_child(character)
	god.selected_characters.append(character) # temp
	return character
