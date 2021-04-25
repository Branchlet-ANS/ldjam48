extends KinematicReal

class_name Entity

enum STATE {
	idle,
	target,
	job,
	attack
}

var _state : int
var velocity : Vector2 = Vector2(0, 0)
var _target : Vector2 = Vector2(0, 0)
var speed : float = 100
var job : Real = null
var job_timer : int = 0
var interact_area : Area2D
var melee_area : Area2D
var attack_timer : int = 0
var attack_target : KinematicReal
var attack_moving : bool = false
var weapon_list : Dictionary = {}
var weapon : Weapon = null
var _health : float = 100.0
var melee_in_range : Array = []
var _power = 2

var player_dead : AudioStreamPlayer2D
var sfx_dead = preload("res://Assets/SFX/dead.wav")
var player_hurt : AudioStreamPlayer2D
var sfx_hurt = preload("res://Assets/SFX/hurt.wav")

func _init(id : String, name: String = "").(id, name):
	weapon_list["Bow"] = Weapon.new("", "", 10, 100, true, 200, "arrow", true, 0.3, 100, "Bow")
	weapon_list["Crossbow"] = Weapon.new("", "", 20, 150, true, 300, "arrow", true, 0.05, 100, "Crossbow")
	weapon_list["Gun"] = Weapon.new("", "", 30, 200, true, 400, "bullet", false, 0.7, 100, "Gun")
	weapon_list["Sword"] = Weapon.new("", "", 5, 25, false, 0, "", false, 0, 10, "Sword")
	weapon_list["Pike"] = Weapon.new("", "", 10, 50, false, 0, "", false, 0, 25, "Pike")
	weapon_list["Halberd"] = Weapon.new("", "", 13, 40, false, 0, "", false, 0, 20, "Halberd")
	weapon_list["Fists"] = Weapon.new("", "", 2, 25, false, 0, "", false, 0, 10, "Fists")
	pass

func _ready():
	player_dead = AudioStreamPlayer2D.new()
	add_child(player_dead)
	player_dead.set_stream(sfx_dead)
	sfx_dead.set_stereo(true)
	player_hurt = AudioStreamPlayer2D.new()
	add_child(player_hurt)
	player_hurt.set_stream(sfx_hurt)
	sfx_hurt.set_stereo(true)

	melee_area = Area2D.new()
	interact_area = Area2D.new()
	var _collision_shape = CollisionShape2D.new()
	var _shape = RectangleShape2D.new()
	_shape.set_extents(Vector2(12, 12))
	_collision_shape.set_shape(_shape)
	var _collision_shape_melee = CollisionShape2D.new()
	var _shape_melee = RectangleShape2D.new()
	_shape_melee.set_extents(Vector2(12, 12))
	_collision_shape_melee.set_shape(_shape)
	collision_layer = 1 << 1
	collision_mask = (1 << 0) + (1 << 2)
	interact_area.add_child(_collision_shape)
	melee_area.add_child(_collision_shape_melee)
	interact_area.connect("body_entered", self, "_on_Area2D_body_entered")
	melee_area.connect("body_entered", self, "_on_melee_Area2D_body_entered")
	melee_area.connect("body_exited", self, "_on_melee_Area2D_body_exited")
	add_child(melee_area)
	add_child(interact_area)

func _process(_delta):
	if get_state() == STATE.idle:
		if is_instance_valid(attack_target):
			set_state(STATE.attack)
		if is_instance_valid(job):
			set_target(job.transform.origin)
	if get_state() == STATE.job:
		perform_job()
	if get_state() == STATE.attack:
		attack_cycle(_delta)

func _physics_process(delta):
	if get_state() == STATE.target:
		velocity = transform.origin.direction_to(_target) * speed
		var velocity_prev = velocity
		velocity = move_and_slide(velocity)
		if transform.origin.distance_to(_target) < speed * delta * (1 if velocity == velocity_prev else 8):
			if is_instance_valid(job) and job.transform.origin == get_target():
				set_state(STATE.job)
			else:
				set_state(STATE.idle)
	if get_state() == STATE.attack:
		var margin = 10
		if(attack_moving):
			margin = 5
		if abs(transform.origin.distance_to(attack_target.position) - weapon.get_desired_distance()) > margin:
			attack_moving = true
			velocity = transform.origin.direction_to(attack_target.position - (transform.origin.direction_to(attack_target.position) * weapon.get_desired_distance())) * speed
			velocity = move_and_slide(velocity)
			if abs(transform.origin.distance_to(attack_target.position) - weapon.get_desired_distance()) < margin/2:
				attack_moving = false

func set_job(interactable):
	job = interactable

func attack(enemy):
	attack_target = enemy
	set_state(STATE.attack)

func get_state():
	return _state

func set_state(state):
	_state = state
	if state == STATE.idle:
		_target = transform.origin
	elif state == STATE.job:
		job_timer = 100
	elif state == STATE.attack:
		attack_timer = 100

func set_target(target):
	_target = target
	set_state(STATE.target)

func perform_job():
	if job == null:
		set_state(STATE.idle)
		return
	job_timer -= 1
	if job_timer == 0:
		job.interact(self)
		job = null
		set_state(STATE.idle)

func attack_cycle(delta):
	if !is_instance_valid(attack_target):
		set_state(STATE.idle)
	attack_timer -= delta
	if attack_timer <= 0:
		strike(attack_target)
		attack_timer = 100

func strike(at):
	print(weapon._desired_distance)
	if(weapon.get_has_projectile()):
		print("test")
		var p = weapon.get_projectile()
		var projectile = Projectile.new("", "", p._speed, p._rotating,
				p._dmg, p._inaccuracy, p._sprite_name, false, Vector2.ZERO, Vector2.ZERO)
		get_parent().add_child(projectile)
		projectile.fire((at.position-position).normalized(), position)
	else:
		for entity in melee_in_range:
			entity.add_health(-weapon.get_dmg())


func get_target():
	return _target

func add_health(amount):
	if (_health + amount) <= 100.0:
		_health += amount
	else:
		_health = 100.0
	if(amount < 0):
		player_hurt.play()


func _on_Area2D_body_entered(body):
	if body is Projectile:
		if (!body.get_owner() == self):
			add_health(-body.get_damage())
			body.call_deferred("free")
