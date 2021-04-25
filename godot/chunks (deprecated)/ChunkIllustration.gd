extends Node2D

func _ready():
	$StopMove/CollisionShape2D.disabled = true
	scale = Vector2(8, 4)
	
func overgrow():
	$Trees.visible = true
	$StopCursor.visible = true
	$StopMove.visible = true
	$StopMove/CollisionShape2D.disabled = false
