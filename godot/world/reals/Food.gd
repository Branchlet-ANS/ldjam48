extends Item

class_name Food

var _food_value: int = 1

func _init(id : String, name : String, food_value : int).(id, name):
	_food_value = food_value
	
func set_food_value(food_value : int) -> void:
	assert(food_value > 0)
	_food_value = food_value

func get_food_value() -> int:
	return _food_value
