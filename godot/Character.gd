extends KinematicBody2D

class_name Character

onready var scene_item = preload("res://Item.gd")
onready var collision_shape = $"CollisionShape2D"

var inventory : Inventory = Inventory.new()
var state : int
var velocity : Vector2 = Vector2(0, 0)
var target : Vector2 = Vector2(0, 0)
var speed : float = 100

func _init():
	pass
	
func _physics_process(delta):
	velocity = transform.origin.direction_to(target) * speed
	velocity = move_and_slide(velocity)
	if transform.origin.distance_to(target) < speed * delta:
		target = transform.origin

func _on_Area2D_body_entered(body):
	if body.get_filename() == "res://Gatherable.tscn":
		inventory.add(body.item)
		body.queue_free()
	
