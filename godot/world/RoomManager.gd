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
	
	var _room
	for i in range(8):
		_room = Room.new(randi() % 32 + 32, randi() % 32 + 32, i)
		_room.foraging_room()
		add(_room)
	for i in range(16):
		add_character()
	select(0)

func add(room : Room):
	_rooms.append(room)

func select(index):
	_index = index
	rebuild()
	
func next():
	assert(_index < _rooms.size()-1)
	_index += 1
	rebuild()
	
func rebuild():
	for child in room_container.get_children():
		if child is Entity:
			child.set_job(null)
			if !(child is Character) or !child.tame:
				child.queue_free()
		else:
			room_container.remove_child(child)
			child.queue_free()
	
	tile_map.clear()
	var room = _rooms[_index]
	var reals = room.get_reals()
	var tiles = room.get_tiles()
	for key in reals:
		var real = reals[key]
		var instance = instance_object(real)
		room_container.add_child(instance)
		instance.set_position(key * TILE_SIZE + TILE_SIZE/2*Vector2(1,1))
		if(real["sprite"] != ""):
			instance.set_sprite(real["sprite"])
		instance.interactable = real["interactable"]
	for key in tiles:
		var tile = tiles[key]
		tile_map.set_cell(key.x, key.y, tile)
		
	for object in room_container.get_children():
		if object.get_id() == "o:room_entrance":
			var characters = []
			for character in get_characters():
				if character.tame:
					characters.append(character)
					character.set_position(object.get_position())
			God.grid_entities(characters, object.get_position(), 15)
			break

func instance_object(info):
	var return_value
	var object = info["object"]
	if object == Real:
		return_value = Real.new(info["id"], info["name"])
	if object == StaticReal:
		return_value = StaticReal.new(info["id"], info["name"])
	if object == Item:
		return_value = Item.new(info["id"], info["name"])
	if object == FoodPlant:
		return_value = FoodPlant.new(info["id"], info["name"], info["value"] * rand_range(0.8, 1.2))
	if object == RoomWeapon:
		return_value = RoomWeapon.new(info["id"], info["name"], info["name"])
	if object == Enemy:
		return_value = Enemy.new(info["id"], info["name"], info["resistance"], info["sense_radius"], info["attack_radius"], info["power"])
	if object == RoomPortal:
		if info["id"] == "o:room_entrance":
			return_value = RoomPortal.new(info["id"], info["name"], -1)
		else:
			return_value = RoomPortal.new(info["id"], info["name"], 1)
	if object == Character:
		var character = Character.new(info["id"], info["name"])
		character._health = randi() % (info["health_max"] - info["health_min"]) + info["health_min"]
		character.weapon = character.weapon_list[info["weapons"][randi() % info["weapons"].size()]]
		return_value = character
	return_value.sprite_offset = info["offset"]
	return return_value

func set_tileset(tile_set):
	tile_map.set_tileset(tile_set)
	
func get_interactables():
	var interactables = []
	for object in room_container.get_children():
		if object.interactable:
			interactables.append(object)
	return interactables

func get_enemies():
	var enemies = []
	for object in room_container.get_children():
		if object is Enemy:
			enemies.append(object)
	return enemies

func get_characters():
	var characters = []
	for object in room_container.get_children():
		if object is Character:
			characters.append(object)
	return characters

func current():
	return _rooms[_index]

func get_width():
	return current().get_width() * TILE_SIZE

func get_height():
	return current().get_height() * TILE_SIZE

func add_character():
	var character = Character.new("o:character")
	character.tame = true
	room_container.add_child(character)
