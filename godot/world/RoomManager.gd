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
	room_container = YSort.new()
	add_child(room_container)

func add(room : Room):
	_rooms.append(room)

func select(index):
	_index = index
	rebuild()
	
func next():
	assert(_index < _rooms.size()-1)
	_index += 1
	rebuild()
	
func previous():
	
	assert(_index > 0)
	_index -= 1
	print(_index)
	print(_rooms[_index])
	rebuild()

func rebuild():
	for child in room_container.get_children():
		if child is Entity:
			child.set_job(null)
			if !(child is Character):
				child.queue_free()
		else:
			room_container.remove_child(child)
			child.queue_free()
	for child in room_container.get_children():
		print(child._name)
	
	tile_map.clear()
	var room = _rooms[_index]
	var reals = room.get_reals()
	var tiles = room.get_tiles()
	for key in reals:
		var real = reals[key]
		var instance = instance_object(real)
		room_container.add_child(instance)
		instance.set_position(key * TILE_SIZE + TILE_SIZE/2*Vector2(1,1))
		instance.set_sprite(real["sprite"])
		instance.interactable = real["interactable"]
	for key in tiles:
		var tile = tiles[key]
		tile_map.set_cell(key.x, key.y, tile)
		
	for object in room_container.get_children():
		if object.get_id() == "o:room_entrance":
			for character in get_parent().characters:
				character.set_position(object.get_position())
			get_parent().grid_entities(get_parent().characters, object.get_position(), 15)
			break

func instance_object(info):
	var object = info["object"]
	if object == Real:
		return Real.new(info["id"])
	if object == StaticReal:
		return StaticReal.new(info["id"])
	if object == Item:
		return Item.new(info["id"], info["name"])
	if object == FoodPlant:
		return FoodPlant.new(info["id"], info["name"], info["value"] * rand_range(0.8, 1.2))
	if object == Enemy:
		return Enemy.new(info["id"])
	if object == RoomPortal:
		if info["id"] == "o:room_entrance":
			return RoomPortal.new(info["id"], info["name"], -1)
		else:
			return RoomPortal.new(info["id"], info["name"], 1)

func set_tileset(tile_set):
	tile_map.set_tileset(tile_set)

func get_interactables():
	var interactables = []
	for object in room_container.get_children():
		if object.interactable:
			interactables.append(object)
	return interactables

func get_monsters():
	var monsters = []
	for object in room_container.get_children():
		if object is Enemy:
			monsters.append(object)
	return monsters

func current():
	return _rooms[_index]

func get_width():
	return current().get_width() * TILE_SIZE

func get_height():
	return current().get_height() * TILE_SIZE
