extends Node2D

class_name Character

var inventory;

func _init():
	inventory = Inventory.new()
	
	inventory.add(Food.new("Apple"))
	inventory.add(Food.new("Apple"))
	inventory.add(Food.new("Apple"))
	inventory.add(Food.new("Banana"))
	inventory.add(Food.new("Banana"))
	
	inventory.remove("Apple", 2)
	
	print(inventory.to_string())
	
