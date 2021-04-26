extends Real

class_name RoomPortal

var _operation : int

func _init(id : String, name : String, operation : int).(id, name):
	assert(operation == -1 or operation == 1)
	_operation = operation
	
func interact(character):
	if _operation == 1:
		get_parent().get_parent().next()
