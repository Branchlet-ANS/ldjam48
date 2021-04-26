extends Entity

class_name Enemy
var _sense_radius
var _attack_radius


func _init(id : String, name: String = "", resistance=100, sense_radius=64, attack_radius=8, power=2).(id, name):
	_resistance = resistance
	_sense_radius = sense_radius
	_attack_radius = attack_radius
	_power = power

var sense_area : Area2D
var target_object : Character = null


func _ready():
	speed = 50
	sense_area = Area2D.new()
	var _collision_shape = CollisionShape2D.new()
	var _shape = CircleShape2D.new()
	_shape.set_radius(_sense_radius)
	_collision_shape.set_shape(_shape)
	sense_area.add_child(_collision_shape)
	sense_area.connect("body_entered", self, "_on_sense_area_body_entered")
	add_child(sense_area)
	
	sfx_hurt = load("res://Assets/SFX/monke" + str(randi()%3+1)+ ".wav")
	player_hurt.set_stream(sfx_hurt)
	sfx_hurt.set_stereo(true)
	sfx_dead = load("res://Assets/SFX/monke4.wav")
	player_dead.set_stream(sfx_dead)
	sfx_dead.set_stereo(true)

func _on_sense_area_body_entered(body):
	if body is Character:
		if get_state() == STATE.idle:
			target_object = body

func _process(delta):
	if is_instance_valid(target_object):
		var distance = get_position().distance_to(target_object.get_position())
		if distance > _sense_radius:
			set_state(STATE.idle)
		elif distance < _attack_radius:
			target_object.add_health(-_power)
			target_object.set_target((target_object.get_position() - get_position()).normalized()*5)
		else:
			set_target(target_object.get_position())
	else:
		target_object = null

func add_health(var amount):
	.add_health(amount)
	if(amount < 0):
		sfx_hurt = load("res://Assets/SFX/monke" + str(randi()%3+1)+ ".wav")
		print(sfx_hurt)
		player_hurt.set_stream(sfx_hurt)
		sfx_hurt.set_stereo(true)
	if _health <= 0:
		#get_parent().remove_child(self)
		queue_free()
	
