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

func register_enemy(id, _name, sprite, corruption, resistance, sense_radius, attack_radius):
	var dict = register_real(id, _name, sprite, corruption, false, Enemy)
	dict["resistance"] = resistance
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
	register_weapon("o:bow", "Bow", "items/bow.png", 7, "weapon", 0.6, 2),
	register_weapon("o:crossbow", "Crossbow", "items/crossbow.png", 7, "weapon", 0.6, 2),
	register_weapon("o:gun", "Gun", "items/gun.png", 7, "weapon", 0.6, 2),
	register_weapon("o:sword", "Sword", "items/sword.png", 7, "weapon", 0.6, 2),
	register_weapon("o:pike", "Pike", "items/pike.png", 7, "weapon", 0.6, 2),
	register_weapon("o:halberd", "Halberd", "items/halberd.png", 7, "weapon", 0.6, 2),
	register_real("o:grass", "Grass", "items/grass.png", 0, false, Real, "foliage"),
	register_real("o:haygrass", "Haygrass", "items/haygrass.png", 1, false, Real, "foliage"),
	register_real("o:rock", "Rock", "items/rock.png", 1, false, StaticReal, "decoration"),
	register_real("o:skeleton1", "Skeleton1", "terrain/dead party/skeleton_man.png", 1, false, StaticReal, "decoration"),
	register_real("o:skeleton2", "Skeleton2", "terrain/dead party/skeleton_man2.png", 1, false, StaticReal, "decoration"),
	register_real("o:skeleton3", "Skeleton3", "terrain/dead party/skeleton_man3.png", 1, false, StaticReal, "decoration"),
	register_real("o:skeleton4", "Skeleton4", "terrain/dead party/skeleton_horse.png", 1, false, StaticReal, "decoration"),
	register_real("o:cart", "Cart", "terrain/dead party/cart.png", 1, false, StaticReal, "decoration"),
	register_real("o:tree", "Tree", "terrain/tree.png", 0, false, StaticReal, "decoration"),
	register_enemy("o:monkey", "Monkey", "animals/monkey.png", 3, 10, 64, 8)
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
	place_real(x0 + 16, y0 + 16, get_object("o:bow"))
	place_real(x0 + 17, y0 + 16, get_object("o:crossbow"))
	place_real(x0 + 18, y0 + 16, get_object("o:gun"))
	place_real(x0 + 16, y0 + 17, get_object("o:pike"))
	place_real(x0 + 17, y0 + 17, get_object("o:halberd"))
	place_real(x0 + 18, y0 + 17, get_object("o:sword"))
	#place_real(x0 + 12, y0 + 8, get_object("o:tree"))
	#place_real(x0 + 14, y0 + 8, get_object("o:tree"))


# Add entrance and exit for procedurally generated room
func proc_room_controls():
	var result = []
	var w = _width
	var h = _height
	var x0 = -w/2
	var y0 = -h/2
	var side = randi() % 4
	for i in range(2):
		var rx = 1 + randi() % (w - 2)
		var ry = 1 + randi() % (h - 2)
		var sx = x0 + [w - 1, rx, 0, rx][side]
		var sy = y0 + [ry, 0, ry, h - 1][side]
		var x1 = sx + [-1, 0, 1, 0][side]
		var y1 = sy + [0, 1, 0, -1][side]
		place_tile(sx, sy, [TILE.sand, TILE.water][i])
		place_real(x1, y1, get_object(["o:room_entrance", "o:room_entrance"][i]))
		side = (side + 2) % 4
		result.append(Vector2(x1, y1))
	return result
	
func two_snakes(start: Vector2, end: Vector2):
	var w = _width
	var h = _height
	var x0 = -w/2
	var y0 = -h/2
	for x in range(x0-8, x0 + w+8): # PADDING
		for y in range(y0-8, y0 + h+8):
			place_tile(x, y, TILE.jungle)
			
	var snake_0_positions = []
	var snake_1_positions = []
	var snake_0 = start
	var snake_1 = end
	var snake_0_dir = start.direction_to(end)
	var snake_1_dir = end.direction_to(start)
	
	while true:
		var snake_0_int = Vector2(int(snake_0.x), int(snake_0.y))
		var snake_1_int = Vector2(int(snake_1.x), int(snake_1.y))
		snake_0_positions.append(snake_0_int)
		snake_1_positions.append(snake_1_int)
		
		if snake_0_int in snake_1_positions \
		or snake_1_int in snake_0_positions:
			break
		
		snake_0_dir = snake_0_dir.rotated(fmod(randf(), PI/8) - PI/16) # SWIRLYNESS
		snake_1_dir = snake_1_dir.rotated(fmod(randf(), PI/8) - PI/16)
		
		snake_0 = Vector2(clamp((snake_0.x + snake_0_dir.x), x0, x0 + w), clamp((snake_0.y + snake_0_dir.y), y0, y0 + h))
		snake_1 = Vector2(clamp((snake_1.x + snake_1_dir.x), x0, x0 + w), clamp((snake_1.y + snake_1_dir.y), y0, y0 + h))
		
	var tiles = snake_0_positions + snake_1_positions
	
	for tile in tiles:
		var s = 2 + randi() % 4 # SNAKE WIDTH
		set_tile_rect(tile.x, tile.y, s, TILE.grass)
	
	set_tile_rect(start.x, start.y, 8, TILE.grass) # SPAWN WIDTH
	place_tile(start.x, start.y, TILE.sand)
	set_tile_rect(end.x, end.y, 8, TILE.grass) # END WIDTH
	place_tile(end.x, end.y, TILE.water)

func set_tile_rect(x, y, size, tile):
	for x0 in range(x - size/2, x + size/2):
		for y0 in range(y - size/2, y + size/2):
			place_tile(x0, y0, tile)

func foraging_room():
	walls()
	var start_end = proc_room_controls()
	two_snakes(start_end[0], start_end[1])
	populate_room(less_corrupt_than(_corruption, get_objects_by("subtype", "berry") + get_objects_by("subtype", "foliage") + get_objects_by("subtype", "decoration")), 0.04)

func bland_room():
	walls()
	populate_room(less_corrupt_than(_corruption, get_objects_by("subtype", "foliage") ), 0.06)
	proc_room_controls()

func monster_room():
	bland_room()

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
