extends StaticReal

class_name Weapon 

var _dmg : float = 10
var _attack_timer : float = 100
var _has_projectile : bool = false
var _projectile_speed : float = 200
var _projectile_sprite_name : String = "bullet"
var _projectile_rotating : bool = false
var _projectile_inaccuracy : float = false
var _projectile : Projectile = null
var _desired_distance : float = 100

func _init(id : String, name: String, dmg : float = 10,
		attack_timer : float = 100,
		has_projectile : bool = false,
		projectile_speed : float = 200,
		projectile_sprite_name : String = "bullet",
		projectile_rotating : bool = false,
		projectile_inaccuracy : float = 0,
		desired_distance : float = 100).(id, name):
	_dmg = dmg
	_attack_timer = attack_timer
	_desired_distance = desired_distance
	if(has_projectile):
		_projectile = Projectile.new("", "", projectile_speed, projectile_rotating,
				dmg, projectile_inaccuracy, projectile_sprite_name, false,
				Vector2.ZERO, Vector2.ZERO)

func get_dmg() -> float:
	return _dmg

func get_attack_timer() -> float:
	return _attack_timer

func get_desired_distance() -> float:
	return _desired_distance

func get_has_projectile() -> bool:
	return _has_projectile

func get_projectile() -> Projectile:
	return _projectile

func get_class():
	return "Weapon"
