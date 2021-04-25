extends Entity

class_name Enemy

func _init(id : String, name: String = "").(id, name):
	pass

var sense_area : Area2D
var target_object : Character = null
var sense_radius = 64

func _ready():
	speed = 50
	sense_area = Area2D.new()
	var _collision_shape = CollisionShape2D.new()
	var _shape = CircleShape2D.new()
	_shape.set_radius(sense_radius)
	_collision_shape.set_shape(_shape)
	sense_area.add_child(_collision_shape)
	sense_area.connect("body_entered", self, "_on_sense_area_body_entered")
	add_child(sense_area)

func _on_sense_area_body_entered(body):
	if body is Character:
		if get_state() == STATE.idle:
			target_object = body

func _process(delta):
	if target_object != null:
		if get_position().distance_to(target_object.get_position()) > sense_radius:
			set_state(STATE.idle)
		else:
			set_target(target_object.get_position())
		
	
