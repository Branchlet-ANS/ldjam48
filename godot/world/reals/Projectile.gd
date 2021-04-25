extends KinematicReal

class_name Projectile

var velocity = Vector2(0, 0)
var speed = 200
var rotating : bool = true

func _init(id : String, name: String = "", parent = null,
		rotating : bool = false, speed : float = 200,
		direction : Vector2 = Vector2.ZERO,
		position : Vector2 = Vector2.ZERO).(id, name):
	print(parent)
	parent.add_child(self)
	
	self.rotating = rotating
	self.velocity = direction * speed
	self.position = position
	
	print(position)
	
	if(rotating):
		rotation = (atan(velocity.y/velocity.x) + PI/2)
		if(velocity.x < 0):
			scale = Vector2(-scale.x, scale.y)
			rotation = (atan(velocity.y/velocity.x) + PI/2 - PI)

func _ready():
	set_sprite("weapons/projectiles/arrow.png")
	var _collision_shape = CollisionShape2D.new()
	var _shape = RectangleShape2D.new()
	_shape.set_extents(Vector2(1.6, 1.6))
	_collision_shape.set_shape(_shape)
	collision_layer = 1 << 1
	collision_mask = (1 << 0) + (1 << 2)

func _physics_process(delta):
	move_and_slide(velocity)
