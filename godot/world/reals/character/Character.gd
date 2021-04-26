extends Entity

class_name Character

var inventory : Inventory = Inventory.new()

var step_pos : Vector2 = Vector2.ZERO
var step_dist : float = 10
var enemy_script = load("res://world/reals/character/Enemy.gd")
var tame = false

func _init(id : String, name: String = "").(id, name):
	pass

func _ready():
	weapon = weapon_list["Fists"]
	
	set_sprite("characters/character.png")
	sprite.set_position(Vector2(0, -8))
	

	step_dist *= rand_range(0.8, 1.2)
	

func _process(_delta):
	if((position - step_pos).length() > 10):
		step_pos = position
		EffectsManager.play_sound("walk1", get_parent().get_parent(), position)

func _on_Area2D_body_entered(body):
	if body is Item:
		inventory.add(body)
		body.get_parent().remove_child(body)

func _on_melee_Area2D_body_entered(body):
	if body is enemy_script:
		melee_in_range.append(body)

func _on_melee_Area2D_body_exited(body):
	if body is enemy_script and body in melee_in_range:
		melee_in_range.erase(body)
		
func add_health(var amount):
	.add_health(amount)
	if _health <= 0:
		EffectsManager.play_sound("dead", get_parent().get_parent(), position)
		get_parent().get_parent().get_parent().get_characters().erase(self)
		if get_parent().get_parent().get_parent().god.selected_characters.has(self):
			get_parent().get_parent().get_parent().god.selected_characters.erase(self)
		get_parent().remove_child(self)
		call_deferred("queue_free")
