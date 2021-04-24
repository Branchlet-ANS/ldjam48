
class_name Item 

var _id : String
var _name : String
var _count : int = 1
var _count_max : int = 8

func _init(id : String, name: String, count = 1):
	_id = id
	_name = name
	_count = count

func get_id() -> String:
	return _id

func get_name() -> String:
	return _name

func get_count() -> int:
	return _count

func get_count_max() -> int:
	return _count_max
		
func set_count(count : int) -> void:
	assert(count >= 0)
	assert(count <= get_count_max())
	_count = count
	
func add(count : int) -> void:
	set_count(get_count() + count)

func remove(count : int) -> void:
	set_count(get_count() - count)

func _to_string() -> String:
	return "{" + str(get_count()) + " "+ str(get_id()) + "}"

func get_class():
	return "Item"
