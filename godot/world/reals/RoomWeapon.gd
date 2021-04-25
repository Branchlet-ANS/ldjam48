extends Real

class_name RoomWeapon

var _weapon_name : String = "Bow"
var player_food : AudioStreamPlayer2D
var sfx_food = preload("res://Assets/SFX/food.wav")

func _init(id : String, name : String, weapon_name : String).(id, name):
	_weapon_name = weapon_name

func _ready():
	player_food = AudioStreamPlayer2D.new()
	add_child(player_food)
	player_food.set_stream(sfx_food)
	sfx_food.set_stereo(true)

func set_weapon_name(weapon_name : String) -> void:
	_weapon_name = weapon_name

func get_weapon_name() -> String:
	return _weapon_name
	
func interact(character):
	print("HELLO")
	print(character.weapon.get_weapon_name())
	if character.weapon != character.weapon_list["Fists"]:
		player_food.play()
		var weapon_old = character.weapon
		character.weapon = character.weapon_list[_weapon_name]
		set_weapon_name(weapon_old)
		set_sprite("items/" + get_weapon_name())
	else:
		character.weapon = character.weapon_list[_weapon_name]
		get_parent().remove_child(self)
		queue_free()
	print(character.weapon.get_weapon_name())
