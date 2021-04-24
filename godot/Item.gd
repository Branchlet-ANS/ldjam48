
class_name Item

var _id : String
var _count : int = 1
var _count_max : int = 8

func _init(id : String):
	_id = id
	
func get_id():
	return _id

func get_count():
	return _count

func get_count_max():
	return _count_max
		
func set_count(count : int):
	assert(count > 0)
	assert(count <= get_count_max())
	_count = count
	
func add(count : int):
	set_count(get_count() + count)

func remove(count : int):
	set_count(get_count() - count)
