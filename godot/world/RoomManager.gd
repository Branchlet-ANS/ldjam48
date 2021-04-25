extends Node2D

class_name RoomManager

export var scene_real : Resource
export var scene_static_real : Resource
export var tileset : TileSet

onready var tile_map : TileMap = $"TileMap"
onready var room_container : YSort = $"RoomContainer"

const TILE_SIZE = 16
var _rooms : Array = []
var _index : int

func _ready():
	set_tileset(tileset)
	tile_map.set_position(Vector2(0.5, 0.5))

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
