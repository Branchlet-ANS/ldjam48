extends Node2D

func _ready():
	pass # Replace with function
	
func overgrow():
	$Trees.visible = true
	$StopCursor.visible = true
	$StopMove.visible = true
	
