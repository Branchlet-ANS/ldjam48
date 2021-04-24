extends Node

class_name Main

onready var scene_item = preload("res://Item.tscn")
onready var script_item = preload("res://Item.gd")
onready var scene_character = preload("res://Character.tscn")
onready var scene_chunk = preload("res://ChunkIllustration.tscn")
onready var god : God = $God

var characters : Array = []

enum Type {BUSH, PATH, OPEN}
const WIDTH = 640
const HEIGHT = 360
const MAP_WIDTH = 32
const MAX_BRANCHES = 3

var map = {}

func _ready():
	var item = scene_item.instance()
	item.transform.origin = Vector2(100, 100)
	add_child(item)
	add_character(0, 0)
	add_character(-100, -100)
	
#
#	for i in range(-MAP_WIDTH/2, MAP_WIDTH/2):
#		for j in range(-MAP_WIDTH/2, MAP_WIDTH/2):
#			var pos = Vector2(i, j)
#			map[pos] = Chunk.new(pos, Type.BUSH, pos.length())
#
#	make_paths()
#
#	for i in range(-MAP_WIDTH/2, MAP_WIDTH/2):
#		for j in range(-MAP_WIDTH/2, MAP_WIDTH/2):
#			var pos = Vector2(i, j)
#			var type = map[pos]._type
#			var ill = scene_chunk.instance()
#			add_child(ill)
#			ill.position = map[pos]._coordinates * 16
#			if type == 0:
#				ill.set_color(Color.green)


func add_character(x : int, y : int) -> Character:
	var character = scene_character.instance()
	character.transform.origin = Vector2(x, y)
	characters.append(character)
	add_child(character)
	god.selected_characters.append(character) # temp
	return character

func make_paths():
	var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	var direction
	randomize()
	var scores = [0]
	var current_position = Vector2(0, 0)
	map[current_position] = Chunk.new(current_position, Type.OPEN, current_position.length())
	for i in range(MAX_BRANCHES):
		scores = [0]
		current_position = Vector2(0, 0)
		while scores.min() < MAP_WIDTH:
			if scores.size() > 5:
				scores.erase(scores.min())
			randomize()
			direction = directions[rand_range(0, 4)]
			while (current_position+direction).length() < scores.min():
				randomize()
				direction = directions[rand_range(0, 4)]
			current_position += direction
			scores.append(current_position.length())
			map[current_position] = Chunk.new(current_position, Type.OPEN, current_position.length())
