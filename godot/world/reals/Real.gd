extends Node2D

class_name Real

var sprite : Sprite

func _init():
	pass
	
func _ready():
	sprite = Sprite.new()
	add_child(sprite)	
	
func set_sprite(path : String):
	sprite.texture = load("res://assets/" + path)
	print("Sprite set!")
