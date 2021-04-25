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

	if reals.has(Vector2(i, j)) and object["object"] != RoomPortal:
		return
	if tiles.has(Vector2(i, j)) and tiles[Vector2(i, j)] == TILE.jungle:
		return
	if i < -_width/2 or j < -_height/2 or i >= _width/2 or j >= _height/2:
		return

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
	sand,
	water,
}


func register_real(id, _name, sprite, corruption, interactable, object, subtype=""):
	return {
		"id": id,
		"name": _name,
		"sprite": sprite,
		"corruption": corruption,
		"interactable": interactable,
		"object": object,
		"subtype": subtype,
		"chance": 1
	}

func register_food_plant(id, _name, sprite, corruption, subtype="", chance=1, value=0):
	var dict = register_real(id, _name, sprite, corruption, true, FoodPlant)
	dict["subtype"] = subtype
	dict["chance"] = chance
	dict["value"] = value
	return dict

func register_weapon(id, _name, sprite, corruption, subtype="", chance=1, value=0):
	var dict = register_real(id, _name, sprite, corruption, true, RoomWeapon)
	dict["subtype"] = subtype
	dict["chance"] = chance
	dict["value"] = value
	return dict

func register_enemy(id, _name, sprite, corruption, health, sense_radius, attack_radius):
	var dict = register_real(id, _name, sprite, corruption, false, Enemy)
	dict["health"] = health
	dict["sense_radius"] = sense_radius
	dict["attack_radius"] = attack_radius
	return dict


var objects_json =  [
	register_real("o:room_entrance", "Room Entrance", "blank_box.png", 0, true, RoomPortal),
	register_real("o:room_exit", "Room Exit", "blank_box.png", 0, true, RoomPortal),
	register_food_plant("o:wangu_berry", "Wangu", "items/wangu.png", 0, "berry", 0.8, 1),
	register_food_plant("o:blue_banana", "Blue Banana", "items/blue_banana.png", 3, "berry", 0.6, 2),
	register_food_plant("o:cherry_berry", "Cherry Berry", "items/cherry_berry.png", 0,"berry", 0.6, 3),
	register_food_plant("o:penis_berry", "Penis Berry", "items/penis_berry.png", 7, "berry", 0.6, -20),
	register_food_plant("o:bow", "Bow", "items/bow.png", 7, "weapon", 0.6, 2),
	register_real("o:grass", "Grass", "items/grass.png", 0, false, Real, "foliage"),
	register_real("o:haygrass", "Haygrass", "items/haygrass.png", 1, false, Real, "foliage"),
	register_real("o:rock", "Rock", "items/rock.png", 1, false, StaticReal, "decoration"),
	register_real("o:tree", "Tree", "terrain/tree.png", 0, false, StaticReal, "decoration"),
	register_enemy("o:monkey", "Monkey", "animals/monkey.png", 3, 10000, 64, 8)
]

func get_objects_by(attribute, term):
	var objects = []
	for object in objects_json:
		if object.has(attribute):
			if str(object[attribute]) == str(term):
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

# Add walls
func walls():
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

	place_real(x0 + 8, y0 + 8, get_object("o:monkey"))
	#place_real(x0 + 12, y0 + 8, get_object("o:tree"))
	#place_real(x0 + 14, y0 + 8, get_object("o:tree"))


# Add entrance and exit for procedurally generated room
func proc_room_controls():

	var tile_positions : Array = [
		Vector2(0, -_height/2),
		Vector2(0, _height/2-1),
		Vector2(-_width/2, 0),
		Vector2(_width/2-1, 0)
		]

	var control_block_positions = [
		Vector2(0, -_height/2+2),
		Vector2(0, _height/2-3),
		Vector2(-_width/2+2, 0),
		Vector2(_width/2-3, 0)
	]

	var r = randi() % 4
	place_tile(tile_positions[r].x, tile_positions[r].y, -1)
	place_real(control_block_positions[r].x, control_block_positions[r].y, get_object("o:room_entrance"))
	control_block_positions.remove(r)
	tile_positions.remove(r)
	r = randi() % 3
	place_tile(tile_positions[r].x, tile_positions[r].y, -1)
	place_real(control_block_positions[r].x, control_block_positions[r].y, get_object("o:room_exit"))
	control_block_positions.remove(r)
	tile_positions.remove(r)

func foraging_room():
	walls()
	populate_room(less_corrupt_than(_corruption, get_objects_by("subtype", "berry") + get_objects_by("subtype", "foliage") + get_objects_by("subtype", "decoration")), 0.04)
	proc_room_controls()

func bland_room():
	walls()
	populate_room(less_corrupt_than(_corruption, get_objects_by("subtype", "foliage") + get_objects_by("subtype", "decoration")), 0.06)
	proc_room_controls()

func monster_room():
	bland_room()
	print("monstuour")

func populate_room(collection : Array, chance : float):
	for i in range(-_width/2, _width/2):
		for j in range(-_height/2, _height/2):
			if rand_range(0, 1) < chance:
				var item = collection[randi() % collection.size()]
				if rand_range(0, 1) < item["chance"]:
					if item["subtype"] == "berry" or item["subtype"] == "foliage":
						for w in range(-2, 3):
							for v in range(-2, 3):
								var spread = 1
								spread *= 1.0/(2*abs(v)+1+2*abs(w))
								if rand_range(0, 1) < spread:
									place_real(i+w, j+v, item)
					else:
						place_real(i, j, item)

func get_width():
	return _width

func get_height():
	return _height
