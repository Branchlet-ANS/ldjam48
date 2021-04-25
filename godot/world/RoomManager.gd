extends Node2D

class_name RoomManager

export var scene_real : Resource
export var scene_static_real : Resource
export var tileset : TileSet

onready var tile_map : TileMap = $"TileMap"

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
	build()
	
func build():
	var room = _rooms[_index]
	var reals = room.get_reals()
	var tiles = room.get_tiles()
	for key in reals:
		var real = reals[key]
		var instance = instance_real(real["object"], real["id"])
		add_child(instance)
		instance.set_position(key * TILE_SIZE)
		instance.set_sprite(real["sprite"])
	for key in tiles:
		var tile = tiles[key]
		tile_map.set_cell(key.x, key.y, tile)
		
func instance_real(object, id):
	if object == Real:
		return Real.new()
	if object == StaticReal:
		return StaticReal.new()
	if object == Item:
		return Item.new(id, "Name")
	
func set_tileset(tile_set):
	tile_map.set_tileset(tile_set)
