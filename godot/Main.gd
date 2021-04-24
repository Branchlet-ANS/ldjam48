extends Node

class_name Main

onready var scene_character = preload("res://Character.tscn")
onready var god : God = $God

const WIDTH = 640
const HEIGHT = 360

var characters : Array = []

func _ready():
	add_character()
	
func add_character() -> Character:
	var character = scene_character.instance()
	characters.append(character)
	add_child(character)
	god.selected_characters.append(character)
	return character
