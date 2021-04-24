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

func _init():
	pass

func _process(delta):
	if get_state() == STATE.idle and jobs.size() > 0:
		if jobs.size() > 0 and is_instance_valid(jobs[0]):
			set_target(jobs[0].transform.origin)
			
func _physics_process(delta):
	if get_state() == STATE.target or get_state() == STATE.job:
		velocity = transform.origin.direction_to(_target) * speed
		velocity = move_and_slide(velocity)
		if transform.origin.distance_to(_target) < speed * delta:
			set_state(STATE.job)

func _on_Area2D_body_entered(body):
	if body.get_filename() == "res://Gatherable.tscn":
		inventory.add(body.get_item())
		body.queue_free()

func add_job(interactable):
	jobs.append(interactable)

func get_state():
	return _state
	
func set_state(state):
	_state = state
	if (state == STATE.idle):
		_target = transform.origin

func set_target(target):
	_target = target
	set_state(STATE.target)

func get_target():
	return _target
