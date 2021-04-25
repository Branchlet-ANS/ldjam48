extends Entity

class_name Character

var inventory : Inventory = Inventory.new()

var player_step : AudioStreamPlayer2D
var sfx_step = preload("res://Assets/SFX/walk1.wav")
var step_pos : Vector2 = Vector2.ZERO
var step_dist : float = 10

func _init(id : String, name: String = "").(id, name):
	weapon = weapon_list["Gun"]
	pass

func _ready():
	set_sprite("characters/character.png")

	player_step = AudioStreamPlayer2D.new()
	add_child(player_step)
	player_step.set_stream(sfx_step)
	sfx_step.set_stereo(true)

	step_dist *= rand_range(0.8, 1.2)

func _process(_delta):
	if((position - step_pos).length() > 10):
		step_pos = position
		if(!player_step.playing):
			player_step.play()

func _on_Area2D_body_entered(body):
	if body is Item:
		inventory.add(body)
		body.get_parent().remove_child(body)
func _on_melee_Area2D_body_entered(body):
	if body is Entity: #hvordan ikke få characters?
		melee_in_range.append(body)

func _on_melee_Area2D_body_exited(body):
	if body is Entity and body in melee_in_range: #hvordan ikke få characters?
		melee_in_range.erase(body)
		
func add_health(var amount):
	.add_health(amount)
	if _health <= 0:
		player_dead.play()
		get_parent().get_parent().get_parent().characters.erase(self)
		if get_parent().get_parent().get_parent().god.selected_characters.has(self):
			get_parent().get_parent().get_parent().god.selected_characters.erase(self)
		get_parent().remove_child(self)
		call_deferred("free")
