extends Entity

class_name Character

var inventory : Inventory = Inventory.new()

var step_pos : Vector2 = Vector2.ZERO
var step_dist : float = 10
var enemy_script = load("res://world/reals/character/Enemy.gd")
var tame = false
var player_anim = preload("res://assets/characters/char_player_anim.tres")

func _init(id : String, name: String = "").(id, name):
	weapon = weapon_list["Fists"]

func _ready():
	sprite.frames = player_anim
	sprite.set_position(Vector2(0, -8))
	step_dist *= rand_range(0.8, 1.2)

func _process(_delta):
	if (position - step_pos).length() > 10:
		step_pos = position
		EffectsManager.play_sound("walk1", get_parent().get_parent(), position)
	if get_state() == STATE.idle:
		sprite.set_animation("idle")
		sprite.frame = 3
		sprite.stop()
	if get_state() == STATE.idle and is_selected():
		var mouse_pos = get_global_mouse_position()
		var angle = 2 * PI - get_position().angle_to_point(mouse_pos)
		sprite.frame = int(angle / (PI / 2.0) - PI / 2.0) % 4
	if get_state() == STATE.target:
		var angle = 2 * PI - get_position().angle_to_point(get_position() + velocity)
		var index = int(angle / (PI / 2.0) - PI / 2.0) % 4
		sprite.set_animation(["right", "up", "left", "down"][index])
		sprite.play()
	if get_state() == STATE.attack:
		attack_cycle(_delta)

func _physics_process(delta):
	if get_state() == STATE.attack:
		if !(is_instance_valid(attack_target)):
			attack_target = null
			set_state(STATE.idle)
			return
		var margin = 10
		if(attack_moving):
			margin = 5
		if(!weapon.get_has_projectile()):
			if transform.origin.distance_to(attack_target.position) > weapon.get_desired_distance():
				attack_moving = true
				var wanted_pos : Vector2 = attack_target.position - weapon.get_desired_distance() * transform.origin.direction_to(attack_target.position)
				move_towards(wanted_pos)
			else:
				var angle = 2 * PI - get_position().angle_to_point(attack_target.position)
				var index = int(angle / (PI / 2.0) - PI / 2.0) % 4
				sprite.set_animation(["right", "up", "left", "down"][index])
		else:
			if abs(transform.origin.distance_to(attack_target.position) - weapon.get_desired_distance()) > margin:
				attack_moving = true
				var wanted_pos : Vector2 = attack_target.position - weapon.get_desired_distance() * transform.origin.direction_to(attack_target.position)
				move_towards(wanted_pos)
				if abs(transform.origin.distance_to(attack_target.position) - weapon.get_desired_distance()) < margin/2:
					attack_moving = false
#			if(!attack_moving):
#				var angle = 2 * PI - get_position().angle_to_point(attack_target.position)
#				var index = int(angle / (PI / 2.0) - PI / 2.0) % 4
#				sprite.set_animation(["right", "up", "left", "down"][index])

func attack_cycle(delta):
	if !is_instance_valid(attack_target):
		set_state(STATE.idle)
	attack_timer -= delta
	if attack_timer <= 0:
		strike(attack_target)
		attack_timer = weapon.get_attack_timer()
		
func is_selected():
	return get_parent().get_parent().get_parent().god.selected_characters.has(self)

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
		#get_parent().remove_child(self)
		call_deferred("queue_free")
	elif(amount < 0):
		EffectsManager.play_sound("hurt", get_parent().get_parent(), position)
