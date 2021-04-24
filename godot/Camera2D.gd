extends Camera2D


const DEACCELERATION = 0.93
const STOP_THRESHOLD = 0.75
const CAMERA_SPEED = 3

var spd_x = 0
var spd_y = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(delta):
	offset += Vector2(spd_x, spd_y)
	spd_x *= DEACCELERATION
	spd_y *= DEACCELERATION
	if (abs(spd_x) < STOP_THRESHOLD):
		spd_x = 0
	if (abs(spd_y) < STOP_THRESHOLD):
		spd_y = 0
	if abs(spd_x) == CAMERA_SPEED and abs(spd_y) == CAMERA_SPEED:
		spd_x = sign(spd_x) * sqrt(1/2*pow(CAMERA_SPEED, 2))
		spd_y = sign(spd_y) * sqrt(1/2*pow(CAMERA_SPEED, 2))
