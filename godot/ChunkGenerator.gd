extends Node2D

onready var scene_chunk = preload("res://ChunkIllustration.tscn")
onready var scene_gatherable = preload("res://Gatherable.tscn")
const MAP_WIDTH = 24
const MAX_BRANCHES = 3
const CHUNK_SIZE = 16
const TILE_SIZE = 16

var map = {}

func _ready():
	for i in range(-MAP_WIDTH/2, MAP_WIDTH/2):
		for j in range(-MAP_WIDTH/2, MAP_WIDTH/2):
			var pos = Vector2(i, j)
			map[pos] = Chunk.new(pos, false, pos.length())

	make_paths()
	for i in range(-MAP_WIDTH/2, MAP_WIDTH/2):
		for j in range(-MAP_WIDTH/2, MAP_WIDTH/2):
			var pos = Vector2(i, j)
			var traversable = map[pos]._traversable
			if traversable:
				var items = map[pos].content
				for posi in items:
					var gatherable = scene_gatherable.instance()
					gatherable.init(Food.new(items[posi]["id"], items[posi]["name"], items[posi]["value"]))
					gatherable.set_position(pos*CHUNK_SIZE*TILE_SIZE + posi*TILE_SIZE)
					add_child(gatherable)
					
			else:
				var ill = scene_chunk.instance()
				add_child(ill)
				ill.position = map[pos]._coordinates * CHUNK_SIZE * TILE_SIZE
				ill.set_size(TILE_SIZE*CHUNK_SIZE)
				ill.set_color(Color.darkgreen)
			

func make_paths():
	var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	var direction
	randomize()
	var scores = [0]
	var current_position = Vector2(0, 0)
	map[current_position] = Chunk.new(current_position, true, current_position.length())
	for i in range(MAX_BRANCHES):
		scores = [0]
		current_position = Vector2(0, 0)
		while scores.max() < MAP_WIDTH:
			if scores.size() > 5:
				scores.erase(scores.min())
			randomize()
			direction = directions[rand_range(0, 4)]
			while (current_position+direction).length() < scores.min():
				randomize()
				direction = directions[rand_range(0, 4)]
			current_position += direction
			scores.append(current_position.length())
			map[current_position] = Chunk.new(current_position, true, current_position.length())
