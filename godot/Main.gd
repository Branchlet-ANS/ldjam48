extends Node

class_name Main

var god : God
var roomManager : RoomManager
var camera : MainCamera

var NUMBER_ROOMS = 2
var NUMBER_CHARACTERS_START = 1

var MIN_ROOM_SIZE = 32
var MAX_ROOM_SIZE = 64


func _ready():
	randomize() # butterfly effect
	
	camera = MainCamera.new()
	add_child(camera)
	camera.current = true
	
	roomManager = RoomManager.new()
	add_child(roomManager)
	roomManager.set_tileset(load("res://world/tileset.tres"))
	roomManager.tile_map.tile_set
	
	god = God.new()
	add_child(god)
	
	for child in roomManager.room_container.get_children():
		if child is Character and child.tame:
			god.selected_characters.append(child)
	

func get_characters():
	return roomManager.get_characters()

func set_room_counter(i):
	$GUI/RoomCounter.text = "Room: " + str(i+1)	

