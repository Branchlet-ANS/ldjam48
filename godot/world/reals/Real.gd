extends KinematicBody2D

class_name Real

var _id : String
var _name : String
var sprite : Sprite
var interactable : bool = false

func _init(id : String, name: String = ""):
	_id = id
	_name = name
	
func _ready():
	sprite = Sprite.new()
	add_child(sprite)	
	
func set_sprite(path : String):
	sprite.texture = load("res://assets/" + path)

func get_id() -> String:
	return _id

func get_name() -> String:
	return _name

func interact(character):
	print(character.get_id() + " has completed an interaction with " + _id)
	
	
