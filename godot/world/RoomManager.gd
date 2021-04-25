extends Node2D

class_name RoomManager

export var scene_real : Resource
export var scene_static_real : Resource

const TILE_SIZE = 16
var tile_map : TileMap
var room_container : YSort
var _rooms : Array = []
var _index : int

func _ready():
	tile_map = TileMap.new()
	add_child(tile_map)
	tile_map.set_cell_size(Vector2(TILE_SIZE, TILE_SIZE))
	tile_map.set_position(Vector2(-0.5, -0.5))
	room_container = YSort.new()
	add_child(room_container)

func add(room : Room):
	_rooms.append(room)

func select(index):
	_index = index
	rebuild()
	
func rebuild():
	for child in room_container.get_children():
		child.queue_free()
	var room = _rooms[_index]
	var reals = room.get_reals()
	var tiles = room.get_tiles()
	for key in reals:
		var real = reals[key]
		var instance = instance_object(real["object"], real["id"])
		room_container.add_child(instance)
		instance.set_position(key * TILE_SIZE)
		print(instance, real["sprite"])
		instance.set_sprite(real["sprite"])
	for key in tiles:
		var tile = tiles[key]
		tile_map.set_cell(key.x, key.y, tile)
		
func instance_object(object, id):
	if object == Real:
		return Real.new(id)
	if object == StaticReal:
		return StaticReal.new(id)
	if object == Item:
		return Item.new(id, "Name")
	
func set_tileset(tile_set):
	tile_map.set_tileset(tile_set)
