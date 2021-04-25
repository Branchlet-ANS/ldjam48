extends KinematicReal

class_name Character

export var scene_item : Resource
export var scene_projectile : Resource

enum STATE {
	idle,
	target,
	job
}

var inventory : Inventory = Inventory.new()
var _state : int
var velocity : Vector2 = Vector2(0, 0)
var _target : Vector2 = Vector2(0, 0)
var speed : float = 100
var jobs : Array = []
var job_timer : int = 0
var interact_area : Area2D

func _init(id : String, name: String = "").(id, name):
	pass

func _ready():
	set_sprite("character.png")
	interact_area = Area2D.new()
	var _collision_shape = CollisionShape2D.new()
	var _shape = RectangleShape2D.new()
	_shape.set_extents(Vector2(12, 12))
	_collision_shape.set_shape(_shape)
	interact_area.add_child(collision_shape)
	interact_area.connect("body_entered", self, "_on_Area2D_body_entered")
	add_child(interact_area)

func _process(_delta):
	if get_state() == STATE.idle and get_jobs().size() > 0:
		if get_jobs().size() > 0 and is_instance_valid(get_jobs()[0]):
			set_target(get_jobs()[0].transform.origin)
	if get_state() == STATE.job:
		perform_job()

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
		body.queue_free()

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
	update()

func set_target(target):
	_target = target
	set_state(STATE.target)

func perform_job():
	job_timer -= 1
	if job_timer == 0:
		get_jobs()[0].queue_free()
		get_jobs().pop_front()
	update()

func strike(pos):
	var projectile = scene_projectile.instance()
	get_parent().add_child(projectile)
	projectile.position = position
	projectile.velocity = projectile.speed * Vector2(pos - position).normalized()
	projectile.late_ready()

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

func _draw():
	if get_state() == STATE.job:
		z_index += 10
		var pos = get_jobs()[0].transform.origin
		var points = PoolVector2Array([pos + Vector2(5, 20), pos + Vector2(-5, 20), pos + Vector2(0, -15)])
		draw_polygon(points, PoolColorArray([Color(0.7, 0.7, 0.7, 0.6)]))
		z_index -= 10
