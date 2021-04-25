extends KinematicReal

class_name Character

enum STATE {
	idle,
	target,
	job,
	attack
}

var inventory : Inventory = Inventory.new()
var _state : int
var velocity : Vector2 = Vector2(0, 0)
var _target : Vector2 = Vector2(0, 0)
var speed : float = 100
var job : Real = null
var job_timer : int = 0
var interact_area : Area2D
var attack_timer : int = 0
var attack_target : KinematicReal
var weapon : int = 0

func _init(id : String, name: String = "").(id, name):
	pass

func _ready():
	set_sprite("character.png")
	interact_area = Area2D.new()
	var _collision_shape = CollisionShape2D.new()
	var _shape = RectangleShape2D.new()
	_shape.set_extents(Vector2(12, 12))
	_collision_shape.set_shape(_shape)
	interact_area.add_child(_collision_shape)
	interact_area.connect("body_entered", self, "_on_Area2D_body_entered")
	add_child(interact_area)
	collision_layer = 1 << 1
	collision_mask = (1 << 0) + (1 << 2)

func _process(_delta):
	if get_state() == STATE.idle and is_instance_valid(job):
		set_target(job.transform.origin)
	if get_state() == STATE.job:
		perform_job()
	if get_state() == STATE.attack:
		attack_cycle(_delta)

func _physics_process(delta):
	if get_state() == STATE.target:
		velocity = transform.origin.direction_to(_target) * speed
		velocity = move_and_slide(velocity)
		if transform.origin.distance_to(_target) < speed * 8 * delta:
			if is_instance_valid(job) and job.transform.origin == get_target():
				set_state(STATE.job)
			else:
				set_state(STATE.idle)

func _on_Area2D_body_entered(body):
	if body is Item:
		inventory.add(body)
		body.get_parent().remove_child(body)

func set_job(interactable):
	job = interactable

func attack(enemy):
	attack_target = enemy
	set_state(STATE.attack)

func get_state():
	return _state

func set_state(state):
	_state = state
	if state == STATE.idle:
		_target = transform.origin
	elif state == STATE.job:
		job_timer = 100
	elif state == STATE.attack:
		attack_timer = 100

func set_target(target):
	_target = target
	set_state(STATE.target)

func perform_job():
	job_timer -= 1
	if job_timer == 0:
		job.interact(self)
		job = null
		set_state(STATE.idle)

func attack_cycle(delta):
	if !is_instance_valid(attack_target):
		set_state(STATE.idle)
	attack_timer -= delta
	print(attack_timer)
	if attack_timer <= 0:
		strike(attack_target.position)
		attack_timer = 100
	
func strike(pos):
	var _projectile = Projectile.new("", "", "Bullet", get_parent(),
		Vector2(pos - position).normalized(), position)
	print("SHOOT!")
	

func get_target():
	return _target
