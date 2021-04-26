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
	
	sprite.frames = SpriteFrames.new()
	_add_animation("idle")
	_add_animation("right")
	_add_animation("up")
	_add_animation("left")
	_add_animation("down")
	sprite.animation = "idle"
	
	sprite.set_position(Vector2(0, -8))
	
	step_dist *= rand_range(0.8, 1.2)


func _add_animation(animation):
	sprite.frames.add_animation(animation)
	for i in range(4):
		sprite.frames.add_frame(animation, load("res://assets/characters/character_" + animation + str(i+1) + ".png"))
	
func _process(_delta):
	if (position - step_pos).length() > 10:
		step_pos = position
		EffectsManager.play_sound("walk1", get_parent().get_parent(), position)
	if get_state() == STATE.idle:
		sprite.animation = "idle"
		sprite.frame = 3
		sprite.stop()
	if get_state() == STATE.idle and is_selected():
		var mouse_pos = get_parent().get_parent().get_parent().camera.mouse_world_position()
		var angle = 2 * PI - get_position().angle_to_point(mouse_pos)
		sprite.frame = int(angle / (PI / 2.0) - PI / 2.0) % 4
	if get_state() == STATE.target:
		var angle = 2 * PI - velocity.angle()
		var index = int(angle / (PI / 2.0) + PI / 4.0) % 4
		sprite.animation = ["right", "up", "left", "down"][index]
		sprite.play()

func _physics_process(delta):
	if get_state() == STATE.attack:
		if !(is_instance_valid(attack_target)):
			attack_target = null
			set_state(STATE.idle)
			return
		var margin = 10
		if(attack_moving):
			margin = 5
		if abs(transform.origin.distance_to(attack_target.position) - weapon.get_desired_distance()) > margin:
			attack_moving = true
			move_towards(_target)
			if abs(transform.origin.distance_to(attack_target.position) - weapon.get_desired_distance()) < margin/2:
				attack_moving = false

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
