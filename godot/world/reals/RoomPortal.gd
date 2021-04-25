extends Real

class_name RoomPortal
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _operation : int

# Called when the node enters the scene tree for the first time.
func _init(id : String, name : String, operation : int).(id, name):
	assert(operation == -1 or operation == 1)
	_operation = operation
	
	
func interact(character):
	if _operation == 1:
		get_parent().get_parent().next()
	else:
		#get_parent().get_parent().previous()
		pass
