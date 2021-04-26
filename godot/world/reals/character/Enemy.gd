extends Entity

class_name Enemy

var _sense_radius
var _attack_radius


func _init(id : String, name: String = "", resistance=100, sense_radius=64, attack_radius=8, power=2, speed=80).(id, name):
	_resistance = resistance
	_sense_radius = sense_radius
	_attack_radius = attack_radius
	_power = power
	speed_max = speed

var sense_area : Area2D
var sensed_characters : Array = []

func _ready():
	sense_area = Area2D.new()
	var _collision_shape = CollisionShape2D.new()
	var _shape = CircleShape2D.new()
	_shape.set_radius(_sense_radius)
	_collision_shape.set_shape(_shape)
	sense_area.add_child(_collision_shape)
	sense_area.connect("body_entered", self, "_on_sense_area_body_entered")
	add_child(sense_area)
	
	last_anim = "idle"
	sprite.animation = "idle"
	sprite.play()

func _on_sense_area_body_entered(body):
	if body is Character:
		sensed_characters.append(body)

func _process(delta):
	if is_instance_valid(attack_target):
		var distance = get_position().distance_to(attack_target.get_position())
		if(distance < _attack_radius and last_anim != "attack"):
			sprite.animation = "attack"
			last_anim = "attack"
			sprite.play()
		elif(distance >= _attack_radius and last_anim != "walk"):
			sprite.animation = "walk"
			last_anim = "walk"
			sprite.play()
		if distance > _sense_radius:
			set_state(STATE.idle)
		elif distance < _attack_radius:
			attack_cycle(delta)
		else:
			move_towards(attack_target.get_position())
	else:
		for character in sensed_characters:
			if is_instance_valid(character):
				set_state(STATE.attack)
				attack_target = character
				break
		if(get_state() == STATE.idle and last_anim != "idle"):
			last_anim = "idle"
			sprite.animation = "idle"
			sprite.play()
	sprite.set_scale(Vector2(sign(velocity.x), 1))

func attack_cycle(delta):
	if !is_instance_valid(attack_target):
		set_state(STATE.idle)
	attack_timer -= delta
	if attack_timer <= 0:
		strike(attack_target)
		attack_timer = 1
		
func _physics_process(delta):
	pass

func strike(at):
	if !is_instance_valid(at):
		return
	at.add_health(-_power)

func add_health(var amount):
	.add_health(amount)
	if(amount < 0):
		if("Mini Monkey" == get_name()):
			var string_sfx = "mini_monke" + str(randi()%3+1)
			EffectsManager.play_sound(string_sfx, get_parent().get_parent(), position)
		elif("Monkey" == get_name()):
			var string_sfx = "monke" + str(randi()%3+1)
			EffectsManager.play_sound(string_sfx, get_parent().get_parent(), position)
		elif("Bird" == get_name()):
			EffectsManager.play_sound("bird1", get_parent().get_parent(), position)
	if _health <= 0:
		#get_parent().remove_child(self)
		if("Mini Monkey" == get_name()):
			EffectsManager.play_sound("mini_monke4", get_parent().get_parent(), position)
		elif("Monkey" == get_name()):
			EffectsManager.play_sound("monke4", get_parent().get_parent(), position)
		elif("Bird" == get_name()):
			EffectsManager.play_sound("bird1", get_parent().get_parent(), position)
		queue_free()
