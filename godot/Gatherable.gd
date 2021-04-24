extends KinematicBody2D

var _item;

func init(item):
	_item = item
	$Sprite.texture = load("res://assets/items/" + _item.get_id() + ".png")
	update()
	
func get_item():
	return _item
