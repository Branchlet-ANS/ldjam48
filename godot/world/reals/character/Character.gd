extends KinematicReal

class_name Character

enum STATE {
	idle,
	target,
	job,
	contact
}

var inventory : Inventory = Inventory.new()
var _state : int
var velocity : Vector2 = Vector2(0, 0)
var _target : Vector2 = Vector2(0, 0)
var speed : float = 100
var jobs : Array = []
var job_timer : int = 0
var interact_area : Area2D
var contact_timer : int = 0
var contact_target : KinematicReal
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
	if get_state() == STATE.idle and get_jobs().size() > 0:
		if get_jobs().size() > 0 and is_instance_valid(get_jobs()[0]):
			set_target(get_jobs()[0].transform.origin)
	if get_state() == STATE.job:
		perform_job()
	if get_state() == STATE.contact:
		contact_cycle(_delta)

func _physics_process(delta):
	if get_state() == STATE.target:
		velocity = transform.origin.direction_to(_target) * speed
		velocity = move_and_slide(velocity)
		if transform.origin.distance_to(_target) < speed * 4 * delta:
			if get_jobs().size() > 0 and get_jobs()[0].transform.origin == get_target():
				set_state(STATE.job)
			else:
				set_state(STATE.idle)

func _on_Area2D_body_entered(body):
	if body is Item:
		inventory.add(body)
		body.get_parent().remove_child(body)

func add_job(interactable):
	get_jobs().append(interactable)

func get_state():
	if _state == STATE.job and get_jobs().size() == 0:
		set_state(STATE.idle)
	return _state

func set_state(state):
	_state = state
	if state == STATE.idle:
		_target = transform.origin
	elif state == STATE.job:
		job_timer = 100
		
func set_target(target):
	_target = target
	set_state(STATE.target)

func perform_job():
	job_timer -= 1
	if job_timer == 0:
		get_jobs()[0].interact(self)
		get_jobs().pop_front()
		set_state(STATE.idle)

func contact_cycle(delta):
	if(!is_instance_valid(contact_target) || contact_target.position == null):
		set_state(STATE.idle)
	contact_timer += delta
	var weapon_max_timer = 3
	if(contact_timer >= weapon_max_timer):
		strike(contact_target.position)
	
func strike(pos):
	var projectile = Projectile.new("", "", "Bullet", get_parent(),
		Vector2(pos - position).normalized(), position)
	pass

func get_target():
	return _target

func get_jobs():
	var i = 0
	while i < jobs.size():
		if (!is_instance_valid(jobs[i])):
			jobs.erase(jobs[i])
			i -= 1
		i += 1
	return jobs
