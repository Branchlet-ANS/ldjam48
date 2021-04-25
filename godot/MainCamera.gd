extends Camera2D

class_name MainCamera

const DEACCELERATION = 0.95
const STOP_THRESHOLD = 1
const CAMERA_SPEED = 200

var spd_x = 0
var spd_y = 0
var x=0
var y=0
var goal_x = 0
var goal_y = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	zoom = Vector2(512.0/1200, 512.0/1200)


func _process(delta):
	offset = Vector2(x, y)
	if Input.is_action_pressed("ui_left"):
		spd_x = -CAMERA_SPEED*delta
	if Input.is_action_pressed("ui_right"):
		spd_x = CAMERA_SPEED*delta
	if Input.is_action_pressed("ui_up"):
		spd_y = -CAMERA_SPEED*delta
	if Input.is_action_pressed("ui_down"):
		spd_y = CAMERA_SPEED*delta
	spd_x *= DEACCELERATION
	spd_y *= DEACCELERATION
	if (abs(spd_x) < STOP_THRESHOLD):
		spd_x = 0
	if (abs(spd_y) < STOP_THRESHOLD):
		spd_y = 0
	if abs(spd_x) == CAMERA_SPEED and abs(spd_y) == CAMERA_SPEED:
		spd_x = sign(spd_x) * sqrt(1/2*pow(CAMERA_SPEED, 2))
		spd_y = sign(spd_y) * sqrt(1/2*pow(CAMERA_SPEED, 2))
	x+=spd_x
	y+=spd_y
	
	

func mouse_world_position():
	return get_viewport().get_mouse_position()*zoom +offset - get_viewport().size/2*zoom
	
