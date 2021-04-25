extends KinematicReal

class_name Projectile

var velocity = Vector2(0, 0)
var speed = 200
var rotating : bool = true
var damage = 10
var timer = 0

func _init(id : String, name: String = "", type : String = "", parent = null,
		direction : Vector2 = Vector2.ZERO, position : Vector2 = Vector2.ZERO).(id, name):
	parent.add_child(self)
	
	speed = 0
	rotating = false
	var inaccuracy = 0
	if(type == "Arrow"):
		speed = 200
		rotating = true
		damage = 7
		inaccuracy = 0.01
		set_sprite("weapons/projectiles/arrow.png")
	elif(type == "Bullet"):
		speed = 400
		rotating = false
		damage = 10
		inaccuracy = 0.5
		set_sprite("weapons/projectiles/bullet.png")
	
	self.rotating = rotating
	direction = (direction * Vector2(1 + rand_range(-inaccuracy, inaccuracy), 1+ rand_range(-inaccuracy, inaccuracy))).normalized()
	self.velocity = direction * speed
	self.position = position
	
	if(rotating):
		rotation = (atan(velocity.y/velocity.x) + PI/2)
		if(velocity.x < 0):
			scale = Vector2(-scale.x, scale.y)
			rotation = (atan(velocity.y/velocity.x) + PI/2 - PI)

func _ready():
	var _collision_shape = CollisionShape2D.new()
	var _shape = RectangleShape2D.new()
	_shape.set_extents(Vector2(1.6, 1.6))
	_collision_shape.set_shape(_shape)
	collision_layer = 1 << 1
	collision_mask = (1 << 0) + (1 << 2)

func _physics_process(delta):
	move_and_slide(velocity)
	timer += delta
	if timer > 10:
		queue_free()
