extends KinematicBody2D

class_name Character

var inventory : Inventory;
var state : int;
var velocity : Vector2 = Vector2(0, 0);
var target : Vector2 = Vector2(0, 0)
var speed : float = 100

func _init():
	inventory = Inventory.new()
	inventory.add(Food.new("Apple"))
	inventory.add(Food.new("Apple"))
	inventory.add(Food.new("Apple"))
	inventory.add(Food.new("Banana"))
	inventory.add(Food.new("Banana"))
	
	inventory.remove("Apple", 2)
	
	print(inventory.to_string())
	
func _physics_process(delta):
	velocity = transform.origin.direction_to(target) * speed
	velocity = move_and_slide(velocity)
	if transform.origin.distance_to(target) < speed * delta:
		target = transform.origin
