
class_name Chunk
var _coordinates: Vector2
var CORRUPTION_MAX = 25
var _type: int
var _left: Chunk
var _right: Chunk
var _up: Chunk
var _down: Chunk
var _corruption: int

func _init(coordinates, type: int, left: Chunk, right: Chunk, up: Chunk, down: Chunk, corruption: int):
	_coordinates = coordinates
	_type = type
	
	_left = left
	_right = right
	_up = up
	_down = down
	
	if _left == null and corruption < CORRUPTION_MAX:
		_left = Chunk.new(_coordinates+Vector2.LEFT, chooseType(Vector2.LEFT), null, self, null, null, corruption+1)
	if _right == null and corruption < CORRUPTION_MAX:
		_right = Chunk.new(_coordinates+Vector2.RIGHT, chooseType(Vector2.RIGHT), self, null, null, null, corruption+1)
	if _up == null and corruption < CORRUPTION_MAX:
		_up = Chunk.new(_coordinates+Vector2.UP, chooseType(Vector2.UP), null, null, null, self, corruption+1)
	if _down == null and corruption < CORRUPTION_MAX:
		_down = Chunk.new(_coordinates+Vector2.DOWN, chooseType(Vector2.DOWN), null, null, self, null, corruption+1)

func chooseType(direction: Vector2):
	#new_coordinates = _coordinates + direction
	return 0
