extends Real

class_name RoomWeapon

var _weapon_name : String = "Bow"

func _init(id : String, name : String, weapon_name : String).(id, name):
	_weapon_name = weapon_name

func _ready():
	pass

func set_weapon_name(weapon_name : String) -> void:
	_weapon_name = weapon_name

func get_weapon_name() -> String:
	return _weapon_name
	
func interact(character):
	print(character.weapon.get_weapon_name())
	if character.weapon != character.weapon_list["Fists"]:
		EffectsManager.play_sound("food", get_parent().get_parent(), position)
		var weapon_old = character.weapon
		character.weapon = character.weapon_list[_weapon_name]
		set_weapon_name(weapon_old.get_weapon_name())
		set_sprite("items/" + get_weapon_name().to_lower() + ".png")
	else:
		character.weapon = character.weapon_list[_weapon_name]
		if is_instance_valid(get_parent()):
			get_parent().remove_child(self)
			queue_free()
