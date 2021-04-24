extends KinematicBody2D

class_name Character

onready var scene_item = preload("res://Item.gd")
onready var collision_shape = $"CollisionShape2D"

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

func _init():
	pass

func _process(delta):
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
	if body.get_filename() == "res://Gatherable.tscn":
		inventory.add(body.get_item())
		body.queue_free()

func add_job(interactable):
	get_jobs().append(interactable)

func get_state():
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
		get_jobs()[0].queue_free()
		get_jobs().pop_front()
	print(job_timer)
	
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
