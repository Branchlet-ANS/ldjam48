extends Camera2D

class_name MainCamera

const DEACCELERATION = 0.85
const STOP_THRESHOLD = 0.1
const CAMERA_SPEED = 200

var velocity = Vector2(0, 0)
var pos = Vector2(0, 0)
var target = Vector2(0, 0)

func _ready():
	zoom = Vector2(0.25, 0.25)

func _process(delta):
	offset = pos
	if Input.is_action_pressed("ui_left"):
		velocity.x = -CAMERA_SPEED*delta
	if Input.is_action_pressed("ui_right"):
		velocity.x = CAMERA_SPEED*delta
	if Input.is_action_pressed("ui_up"):
		velocity.y = -CAMERA_SPEED*delta
	if Input.is_action_pressed("ui_down"):
		velocity.y = CAMERA_SPEED*delta
	velocity *= DEACCELERATION
	if (velocity.length() < STOP_THRESHOLD):
		velocity = Vector2.ZERO
	if velocity.length() == CAMERA_SPEED:
		velocity *= sqrt(1/2*pow(CAMERA_SPEED, 2))
	pos += velocity

func mouse_world_position():
	return get_viewport().get_mouse_position()*zoom +offset - get_viewport().size/2*zoom
	
