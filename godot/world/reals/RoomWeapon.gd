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
	print(character.weapon.name)
	if character.weapon != character.weapon_list["Fists"]:
		player_food.play()
		#Legg gamle våpnet på bakken
		character.weapon = character.weapon_list[_weapon_name]
		#Slett våpenet
	else:
		character.weapon = character.weapon_list[_weapon_name]
		#Slett våpenet
	print(character.weapon.name)
