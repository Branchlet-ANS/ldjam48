extends Node

class_name Main

var god : God
var roomManager : RoomManager
var camera : MainCamera

func _ready():
	randomize() # butterfly effect
	
	camera = MainCamera.new()
	add_child(camera)
	camera.current = true
	
	roomManager = RoomManager.new()
	add_child(roomManager)
	roomManager.set_tileset(load("res://world/tileset.tres"))
	
	god = God.new()
	add_child(god)

func get_characters():
	return roomManager.get_characters()
