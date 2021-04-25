extends Node2D


export var scene_chunk_illustration : Resource
export var scene_gatherable : Resource

const MAP_WIDTH = 84
const MAX_BRANCHES = 1
const TILE_SIZE = 16
const CHUNK_WIDTH = 64
const CHUNK_HEIGHT = 32

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

			var tiles = scene_chunk_illustration.instance()
			add_child(tiles)
			tiles.position = map[pos]._coordinates * Vector2(CHUNK_WIDTH, CHUNK_HEIGHT) * TILE_SIZE

			if traversable:
				var items = map[pos].content
				for posi in items:
					var gatherable = scene_gatherable.instance()
					gatherable.init(Food.new(items[posi]["id"], items[posi]["name"], items[posi]["value"]))
					gatherable.set_position(pos*Vector2(CHUNK_WIDTH, CHUNK_HEIGHT)*TILE_SIZE + posi*TILE_SIZE+Vector2(8, 8))
					add_child(gatherable)
			else:
				tiles.overgrow()

func make_paths():
	var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	var direction
	randomize()
	var scores = [0]
	var current_position = Vector2(0, 0)
	map[current_position] = Chunk.new(current_position, true, current_position.length())
	for _i in range(MAX_BRANCHES):
		scores = [0]
		current_position = Vector2(0, 0)
		while scores.max() < MAP_WIDTH/2:
			if scores.size() > 2:
				scores.erase(scores.min())
			randomize()
			direction = directions[rand_range(0, 4)]
			while (current_position+direction).length() < scores.min():
				randomize()
				direction = directions[rand_range(0, 4)]
			current_position += direction
			scores.append(current_position.length())
			map[current_position] = Chunk.new(current_position, true, current_position.length())