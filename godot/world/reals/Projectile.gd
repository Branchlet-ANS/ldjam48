extends KinematicBody2D

var velocity = Vector2(0, 0)
var speed = 200
var rotate : bool = true

func _ready():
	pass

# called when all variables are set
func late_ready():
	if(rotate):
		rotation = (atan(velocity.y/velocity.x) + PI/2)
		if(velocity.x < 0):
			scale = Vector2(-scale.x, scale.y)
			rotation = (atan(velocity.y/velocity.x) + PI/2 - PI)

func _physics_process(delta):
	move_and_slide(velocity)
