extends KinematicReal

class_name Projectile

var _velocity = Vector2(0, 0)
var _speed = 200
var _rotating : bool = true
var _dmg = 10
var _timer = 0
var _fired = false
var _sprite_name : String = ""
var _inaccuracy = 0

func _init(id : String, name: String = "", speed : float = 200,
		rotating : bool = false, dmg : float = 10, inaccuracy : float = 0,
		sprite_name : String = "bullet", fired : bool = false,
		direction : Vector2 = Vector2.ZERO, position : Vector2 = Vector2.ZERO).(id, name):
	
	_speed = speed
	_rotating = rotating
	_dmg = dmg
	_fired = fired
	_inaccuracy = inaccuracy
	_sprite_name = sprite_name
	if(_fired):
		fire(direction, position)
	print("init")

func _ready():
	print("ready")
	print(_sprite_name)
	set_sprite("weapons/projectiles/" + _sprite_name + ".png")
	var _collision_shape = CollisionShape2D.new()
	var _shape = RectangleShape2D.new()
	_shape.set_extents(Vector2(1.6, 1.6))
	_collision_shape.set_shape(_shape)
	collision_layer = 1 << 1
	collision_mask = (1 << 0) + (1 << 2)

func fire(direction, position):
	_fired = true
	var _direction = (direction * Vector2(1 + rand_range(-_inaccuracy, _inaccuracy), 1+ rand_range(-_inaccuracy, _inaccuracy))).normalized()
	_velocity = _direction * _speed
	self.position = position
	
	if(_rotating):
		rotation = (atan(_velocity.y/_velocity.x) + PI/2)
		if(_velocity.x < 0):
			scale = Vector2(-scale.x, scale.y)
			rotation = (atan(_velocity.y/_velocity.x) + PI/2 - PI)

func _physics_process(delta):
	if(!_fired):
		return
	move_and_slide(_velocity)
	_timer += delta
	if _timer > 10:
		queue_free()
