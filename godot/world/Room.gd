extends Node2D

class_name Room

var _width : int
var _height : int
var _corruption : float

var reals = {}
var tiles = {}

func _init(width, height, corruption=0):
	_width = width
	_height = height
	_corruption = corruption

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

func register_real(id, _name, sprite, corruption, object, subtype="", chance=1): # temp
	return {
		"id": id,
		"name": _name,
		"sprite": sprite,
		"corruption": corruption,
		"object": object,
		"subtype": subtype,
		"chance": chance
	}

var objects_json =  [
	register_real("o:room_entrance", "Room Entrance", "programmer_bed.png", 0, Real),
	register_real("o:room_exit", "Room Exit", "programmer_campfire.png", 0, Real),
	register_real("o:tree", "Tree", "programmer_spike.png", 0, StaticReal),
	register_real("o:wangu_berry", "Wangu", "items/wangu.png", 0, Item, "berry"),
	register_real("o:blue_banana", "Blue Banana", "items/blue_banana.png", 0, Item, "berry", 0.7),
	register_real("o:cherry_berry", "Cherry Berry", "items/cherry_berry.png", 0, Item, "berry", 0.6),
	register_real("o:cherry_berry", "Cherry Berry", "items/cherry_berry.png", 0, Item, "berry", 0.2),
	register_real("o:penis_berry", "Penis Berry", "items/penis_berry.png", 3, Item, "berry", 0.3)
]

func get_objects_by(attribute, term):
	var objects = []
	for object in objects_json:
		if object[attribute] == term:
			objects.append(object)
	return objects

func less_corrupt_than(corruption : float, list : Array):
	var return_list = []
	for object in list:
		if object["corruption"] <= corruption:
			return_list.append(object)
	return return_list

func get_object(id):
	for object in objects_json:
		if object["id"] == id:
			return object

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
	_corruption = 5
	foraging_room()
	place_real(x0 + 2, y0 + 2, get_object("o:room_entrance"))
	place_real(x0 + w - 3, y0 + h - 3, get_object("o:room_exit"))
	#place_real(x0 + 7, y0 + 7, get_object("o:tree"))
	#place_real(x0 + 8, y0 + 8, get_object("o:berry"))

func foraging_room():
	populate_room(less_corrupt_than(_corruption, get_objects_by("subtype", "berry")), 0.03)
	
func bland_room():
	#generate forage
	pass
	
func monster_room():
	#generate forage
	pass
	
func populate_room(collection : Array, chance : float):
	for i in range(-_width/2, _width/2):
		for j in range(-_height/2, _height/2):
			if rand_range(0, 1) < chance:
				var item = collection[randi() % collection.size()]
				if rand_range(0, 1) < item["chance"]:
					place_real(i, j, item)
