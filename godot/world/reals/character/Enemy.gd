extends Entity

class_name Enemy

func _init(id : String, name: String = "").(id, name):
	pass

var sense_area : Area2D

func _ready():
	sense_area = Area2D.new()
	var _collision_shape = CollisionShape2D.new()
	var _shape = CircleShape2D.new()
	_shape.set_radius(48)
	_collision_shape.set_shape(_shape)
	sense_area.add_child(_collision_shape)
	sense_area.connect("body_entered", self, "_on_sense_area_body_entered")
	add_child(sense_area)

func _on_sense_area_body_entered(body):
	if body is Character:
		if get_state() == STATE.idle:
			set_target(body.get_position())
