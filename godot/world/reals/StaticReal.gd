extends Real

class_name StaticReal

var collision_shape : CollisionShape2D

func _init(id : String, name: String = "").(id, name):
	pass
	
func _ready():
	collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(8, 8))
	collision_shape.set_shape(shape)
	add_child(collision_shape)	
