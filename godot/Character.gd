extends Node2D

class_name Character

var inventory;

func _init():
	inventory = Inventory.new()
	
	inventory.add(Item.new("Apple"))
	inventory.add(Item.new("Apple"))
	inventory.add(Item.new("Apple"))
	inventory.add(Item.new("Banana"))
	inventory.add(Item.new("Banana"))
	
	inventory.remove("Apple", 2)
	
	print(inventory.to_string())
	
