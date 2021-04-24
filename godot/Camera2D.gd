extends Camera2D


const DEACCELERATION = 1
const STOP_THRESHOLD = 0.5
const CAMERA_SPEED = 200

var spd_x = 0
var spd_y = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	zoom = Vector2(256.0/800, 256.0/800)


func _process(delta):
	offset += Vector2(spd_x * delta, spd_y * delta)
	
	spd_x *= DEACCELERATION * delta
	spd_y *= DEACCELERATION * delta
	if (abs(spd_x) < STOP_THRESHOLD):
		spd_x = 0
	if (abs(spd_y) < STOP_THRESHOLD):
		spd_y = 0
	if abs(spd_x) == CAMERA_SPEED and abs(spd_y) == CAMERA_SPEED:
		spd_x = sign(spd_x) * sqrt(1/2*pow(CAMERA_SPEED, 2))
		spd_y = sign(spd_y) * sqrt(1/2*pow(CAMERA_SPEED, 2))

func screen_position(event):
	return event.get_position() - get_viewport_rect().size/2 + offset
