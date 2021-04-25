extends Node2D

class_name Room

var _width : int
var _height : int

var reals = {}
var tiles = {}

func _init(width, height):
	_width = width
	_height = height

func place_real(i : int, j : int, object):
	reals[Vector2(i, j)] = object

func place_tile(i : int, j : int, tile):
	tiles[Vector2(i, j)] = tile

func get_reals():
	return reals
	
func get_tiles():
	return tiles

enum TILE {
	jungle,
	grass,
	water,
	sand,
}

func register_real(id, sprite, corruption, object): # temp
	return {
		"id": id,
		"sprite": sprite,
		"corruption": corruption,
		"object": object
	}

var objects_json =  {
	"o:room_entrance": register_real("o:room_entrance", "programmer_bed.png", 0, Real),
	"o:room_exit": register_real("o:room_exit", "programmer_campfire.png", 0, Real),
	"o:tree": register_real("o:tree", "programmer_spike.png", 0, StaticReal),
	"o:berry": register_real("o:berry", "items/wangu.png", 0, Item),
}

func basic_room(): # temp
	var x0 = -_width/2
	var y0 = -_height/2
	var w = _width
	var h = _height
	for x in range(x0, x0 + w):
		for y in range(y0, y0 + h):
			if (x == x0 or x == x0 + w - 1 or y == y0 or y == y0 + h - 1):
				place_tile(x, y, TILE.jungle)
			else:
				place_tile(x, y, TILE.grass)
	place_real(x0 + 2, y0 + 2, objects_json["o:room_entrance"])
	place_real(x0 + w - 3, y0 + h - 3, objects_json["o:room_exit"])
	place_real(x0 + 7, y0 + 7, objects_json["o:tree"])
	place_real(x0 + 8, y0 + 8, objects_json["o:berry"])

