extends Node


class_name Chunk
enum Type {BUSH, PATH, OPEN}

var _coordinates: Vector2
var _type: int
var _corruption: float

func _init(coordinates: Vector2, type: int, corruption: float):
	_coordinates = coordinates
	_type = type
	_corruption = corruption

func _to_string():
	if _type == Type.BUSH:
		return "BUSH"
	elif _type == Type.OPEN:
		return "OPEN"
	elif _type == Type.PATH:
		return "PATH"
	else:
		return "NULL"
