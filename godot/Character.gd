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
var target : Vector2 = Vector2(0, 0)
var speed : float = 100
var jobs : Array = []

func _init():
	pass

func _process(delta):
	if get_state() == STATE.idle and jobs.size() > 0:
		set_state(STATE.job)
	if get_state() == STATE.job:
		if jobs.size() > 0 and is_instance_valid(jobs[0]):
			target = jobs[0].transform.origin
		else:
			set_state(STATE.idle)
			
func _physics_process(delta):
	if get_state() == STATE.target or get_state() == STATE.job:
		velocity = transform.origin.direction_to(target) * speed
		velocity = move_and_slide(velocity)
		if transform.origin.distance_to(target) < speed * delta:
			if get_state() == STATE.job:
				if jobs.size() > 0 and is_instance_valid(jobs[0]):
					jobs[0].queue_free()
				jobs.pop_front()
			set_state(STATE.idle)

func _on_Area2D_body_entered(body):
	if body.get_filename() == "res://Gatherable.tscn":
		inventory.add(body.item)
		body.queue_free()

func add_job(interactable):
	jobs.append(interactable)

func get_state():
	return _state
	
func set_state(state):
	_state = state
	if (state == STATE.idle):
		target = transform.origin

