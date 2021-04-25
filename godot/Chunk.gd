extends Node


class_name Chunk
enum Type {BUSH, PATH, OPEN}
const CHUNK_WIDTH = 64
const CHUNK_HEIGHT = 32

enum ItemTypes {
	FOLIAGE = 0,
	FOOD = 1
}

var food_register = [
	{
		"name": "Wangu",
		"id": "wangu",
		"value": 4,
		"corruption": 0
	},
	{
		"name": "Cherry Berry",
		"id": "cherry_berry",
		"value": -2,
		"corruption": 0,
	},
	{
		"name": "Penis Berry",
		"id": "penis_berry",
		"value": -3,
		"corruption": 7
	}
	
]

var foliage_register = [
	{
		"id": "grass",
		"name": "Grass",
		"value": 0,
		"corruption": 0
	},
	{
		"id": "haygrass",
		"name": "Haygrass",
		"value": 0,
		"corruption": 1
	}
]

var _coordinates: Vector2
var _traversable: bool
var _corruption: float
var content = {}

func _init(coordinates: Vector2, traversable: bool, corruption: float):	
	_coordinates = coordinates
	_traversable = traversable
	_corruption = corruption
	if _traversable:
		randomize()
		var r = rand_range(0, 7)
		if r < 1:
			monster_chunk()
		elif r < 3:
			foraging_chunk()
		elif r < 7:
			bland_chunk()

func monster_chunk():
	# Check corruption and add monsters to content array
	pass
func foraging_chunk():
	var available_food: Array = get_by_corruption(_corruption, food_register)
	var available_foliage: Array = get_by_corruption(_corruption, foliage_register)
	add_items(available_food, 0.02)
	add_items(available_foliage, 0.05)
				
func bland_chunk():
	var available_foliage: Array = get_by_corruption(_corruption, foliage_register)
	add_items(available_foliage, 0.05);
	
func get_content() -> Dictionary:
	return content
	
func get_by_corruption(corruption, dict: Array):
	var items = []
	for item in dict:
		if item["corruption"] <= corruption:
			items.append(item)
	return items
		
func add_items(collection : Array, chance : float): 
	for i in range(-CHUNK_WIDTH/2+1, CHUNK_WIDTH/2-1):
		for j in range(-CHUNK_HEIGHT/2+1, CHUNK_HEIGHT/2-1):
			randomize()
			if rand_range(0, 1) < chance: 
				content[Vector2(i, j)] = collection[randi() % collection.size()]
