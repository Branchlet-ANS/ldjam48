extends Camera2D

class_name MainCamera

const DEACCELERATION = 1
const STOP_THRESHOLD = 0.5
const CAMERA_SPEED = 200

#var spd_x = 0
#var spd_y = 0
var x=0
var y=0
var goal_x = 0
var goal_y = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	zoom = Vector2(312.0/400, 312.0/400)


func _process(delta):
	offset = Vector2((3*x+goal_x)/4, (3*y+goal_y)/4)
	x = (3*x + goal_x)/4
	y = (3*y + goal_y)/4
	
#	spd_x *= DEACCELERATION * delta
#	spd_y *= DEACCELERATION * delta
#	if (abs(spd_x) < STOP_THRESHOLD):
#		spd_x = 0
#	if (abs(spd_y) < STOP_THRESHOLD):
#		spd_y = 0
#	if abs(spd_x) == CAMERA_SPEED and abs(spd_y) == CAMERA_SPEED:
#		spd_x = sign(spd_x) * sqrt(1/2*pow(CAMERA_SPEED, 2))
#		spd_y = sign(spd_y) * sqrt(1/2*pow(CAMERA_SPEED, 2))
	
	if Input.is_action_just_pressed("ui_left"):
		goal_x -= 1024
	if Input.is_action_just_pressed("ui_right"):
		goal_x += 1024
	if Input.is_action_just_pressed("ui_up"):
		goal_y -= 512
	if Input.is_action_just_pressed("ui_down"):
		goal_y += 512

func mouse_world_position():
	return get_viewport().get_mouse_position()*zoom +offset - get_viewport().size/2*zoom
	
