extends Node2D

class_name Room

var _width : int
var _height : int
var _corruption : float
var register = Register.new()

var reals = {}
var tiles = {}

var w = _width
var h = _height
var x0 = -w/2
var y0 = -h/2
var PADDING = 32

func _init(width, height, corruption=0):
	_width = width
	_height = height
	_corruption = corruption
	w = _width
	h = _height
	x0 = -w/2
	y0 = -h/2
	
func place_real(i : int, j : int, info):
	if info["object"] == RoomPortal:
		reals[Vector2(i, j)] = info
	else:
		if reals.has(Vector2(i, j)) and info["object"] != RoomPortal:
			return
		if tiles.has(Vector2(i, j)) and tiles[Vector2(i, j)] == TILE.jungle:
			return
		if i < x0 or j < y0 or i >= x0 + w or j >= y0 + h:
			return
		reals[Vector2(i, j)] = info
		
func place_tile(i : int, j : int, tile):
	tiles[Vector2(i, j)] = tile

func get_reals():
	return reals

func get_tiles():
	return tiles

enum TILE {
	jungle,
	jungle_dark,
	jungle_lt,
	jungle_rt,
	jungle_lb,
	jungle_rb,
	grass,
	grass1,
	grass2,
	sand,
	water,
}

func walls():
	for x in range(x0, x0 + w):
		for y in range(y0, y0 + h):
			if (x == x0 or x == x0 + w - 1 or y == y0 or y == y0 + h - 1):
				place_tile(x, y, TILE.jungle)
			else:
				place_tile(x, y, TILE.grass)

func proc_room_controls():
	var result = []
	var side = randi() % 4
	for i in range(2):
		var rx = 1 + randi() % (w - 2)
		var ry = 1 + randi() % (h - 2)
		var sx = x0 + [w - 1, rx, 0, rx][side]
		var sy = y0 + [ry, 0, ry, h - 1][side]
		var x1 = sx + [-1, 0, 1, 0][side]
		var y1 = sy + [0, 1, 0, -1][side]
		side = (side + 2) % 4
		result.append(Vector2(x1, y1))
	return result

func two_snakes(start: Vector2, end: Vector2):
	for x in range(x0-PADDING, x0 + w+PADDING): # PADDING
		for y in range(y0-PADDING, y0 + h+PADDING):
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

	var snake_tiles = snake_0_positions + snake_1_positions

	for tile in snake_tiles:
		var s = 4 + randi() % 4 # SNAKE WIDTH
		set_tile_rect(tile.x, tile.y, s, TILE.grass)
	
	set_tile_rect(start.x, start.y, 4, TILE.grass) # SPAWN WIDTH
	place_real(start.x, start.y, register.get_object("o:place_characters_here"))
	#set_tile_rect(end.x, end.y, 8, TILE.grass) # END WIDTH
	#
	
	var i = 0
	while tiles[Vector2(start.x, start.y)] == TILE.grass:
		if i % 2 == 0:
			start.x += sign(start.x)
		else:
			start.y += sign(start.y)
		i += 1
	while tiles[Vector2(end.x, end.y)] == TILE.grass:
		if i % 2 == 0:
			end.x += sign(end.x)
		else:
			end.y += sign(end.y)
		i += 1
	
	place_real(start.x, start.y, register.get_object("o:room_entrance"))
	place_real(end.x, end.y, register.get_object("o:room_exit"))
	place_tile(start.x, start.y, -1)
	place_tile(end.x, end.y, -1)
	
func set_tile_rect(sx, sy, size, tile):
	for x in range(sx - size/2, sx + size/2):
		for y in range(sy - size/2, sy + size/2):
			place_tile(x, y, tile)

func prettify_tiles():
	var jungles = [TILE.jungle, TILE.jungle_dark, TILE.jungle_rt, TILE.jungle_lt, TILE.jungle_lb, TILE.jungle_rb]
	var jungle_bottoms = [TILE.jungle_lb, TILE.jungle_rb]
	var jungle_leaves = [TILE.jungle, TILE.jungle_dark]
	var grasses = [TILE.grass, TILE.grass1, TILE.grass2]

	for i in range(2):
		for x in range(x0-PADDING, x0 + w+PADDING): # PADDING
			for y in range(y0-PADDING, y0 + h+PADDING):
				var tile = tiles[Vector2(x, y)]
				var right = tiles[Vector2(x+1, y)] if tiles.has(Vector2(x+1, y)) else -1
				var top = tiles[Vector2(x, y-1)] if tiles.has(Vector2(x, y-1)) else -1
				var left = tiles[Vector2(x-1, y)] if tiles.has(Vector2(x-1, y)) else -1
				var bottom = tiles[Vector2(x, y+1)] if tiles.has(Vector2(x, y+1)) else -1
				if jungles.has(tile) and jungles.has(top) and grasses.has(bottom):
					place_tile(x, y, TILE.jungle_lb if x % 2 == 0 else TILE.jungle_rb)
				if jungles.has(tile) and jungles.has(top) and jungle_bottoms.has(bottom):
					place_tile(x, y, TILE.jungle_lt if x % 2 == 0 else TILE.jungle_rt)
	
	for x in range(x0-PADDING, x0 + w+PADDING): # PADDING
		for y in range(y0-PADDING, y0 + h+PADDING):
			var tile = tiles[Vector2(x, y)]
			var right = tiles[Vector2(x+1, y)] if tiles.has(Vector2(x+1, y)) else -1
			var top = tiles[Vector2(x, y-1)] if tiles.has(Vector2(x, y-1)) else -1
			var left = tiles[Vector2(x-1, y)] if tiles.has(Vector2(x-1, y)) else -1
			var bottom = tiles[Vector2(x, y+1)] if tiles.has(Vector2(x, y+1)) else -1
			if tile == TILE.grass and (randi() % 10 < 1 or (jungles.has(right) or jungles.has(top) or jungles.has(left) or jungles.has(bottom))):
				place_tile(x, y, grasses[randi() % 3])
			if tile == TILE.jungle and (jungle_leaves.has(right) and jungle_leaves.has(top) and jungle_leaves.has(left) and jungle_leaves.has(bottom)):
				place_tile(x, y, TILE.jungle_dark)

func tiles_set_corruption(corruption):
	for x in range(x0-PADDING, x0 + w+PADDING): # PADDING
		for y in range(y0-PADDING, y0 + h+PADDING):
			var tile = tiles[Vector2(x, y)] % 11
			place_tile(x, y, tile + 11 * corruption)

func foraging_room():
	walls()
	var start_end = proc_room_controls()
	two_snakes(start_end[0], start_end[1])
	populate_room(
		register.less_corrupt_than(_corruption,
			register.get_objects_by("subtype", ["berry", "foliage", "decoration", "enemy", "character", "weapon"])
		), 0.07
	)
	prettify_tiles()
	tiles_set_corruption(min(floor(_corruption/3), 3))
#
#func bland_room():
#	walls()
#	populate_room(register.less_corrupt_than(_corruption, register.get_objects_by("subtype", "foliage") ), 0.06)
#	proc_room_controls()
#
#func monster_room():
#	bland_room()

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
