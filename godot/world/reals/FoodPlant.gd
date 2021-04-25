extends Real

class_name FoodPlant

var _food_value: int = 1
var _fruits : int

func _init(id : String, name : String, food_value : int).(id, name):
	_food_value = food_value
	_fruits = 1
	
	
func set_food_value(food_value : int) -> void:
	assert(food_value > 0)
	_food_value = food_value

func get_food_value() -> int:
	return _food_value
	
func interact(character):
	if _fruits > 0:
		character.add_health(_food_value)
		_fruits -= 1
	if _fruits == 0:
		set_sprite("terrain/bush.png")
