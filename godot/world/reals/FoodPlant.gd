extends Real

class_name FoodPlant

var _food_value: int = 1
var _fruits : int

func _init(id : String, name : String, food_value : int).(id, name):
	_food_value = food_value
	_fruits = 1

func _ready():
	pass

func set_food_value(food_value : int) -> void:
	assert(food_value > 0)
	_food_value = food_value

func get_food_value() -> int:
	return _food_value
	
func interact(character):
	if _fruits > 0:
		EffectsManager.play_sound("food", get_parent().get_parent(), position)
		get_parent().get_parent().get_parent().get_node("GUI/Achievement").berry(_name)
		if _food_value < 0:
			achievement("Bad luck!", "You were damaged by eating poisonous berries!")
		else:
			achievement("Delicious!", "You were healed by eating berries!")
		
		character.add_health(_food_value)
		_fruits -= 1
	if _fruits == 0:
		set_sprite("terrain/bush.png")
	
