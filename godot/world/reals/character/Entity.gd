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
var attack_timer : int = 0
var attack_target : KinematicReal
var attack_moving : bool = false
var weapon : Weapon = null
var _health : float = 100.0

var player_dead : AudioStreamPlayer2D
var sfx_dead = preload("res://Assets/SFX/dead.wav")
var player_hurt : AudioStreamPlayer2D
var sfx_hurt = preload("res://Assets/SFX/hurt.wav")

func _init(id : String, name: String = "").(id, name):
	pass

func _ready():
	player_dead = AudioStreamPlayer2D.new()
	add_child(player_dead)
	player_dead.set_stream(sfx_dead)
	player_hurt = AudioStreamPlayer2D.new()
	add_child(player_hurt)
	player_hurt.set_stream(sfx_hurt)
	
	interact_area = Area2D.new()
	var _collision_shape = CollisionShape2D.new()
	var _shape = RectangleShape2D.new()
	_shape.set_extents(Vector2(12, 12))
	_collision_shape.set_shape(_shape)
	collision_layer = 1 << 1
	collision_mask = (1 << 0) + (1 << 2)
	interact_area.add_child(_collision_shape)
	interact_area.connect("body_entered", self, "_on_Area2D_body_entered")
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
		strike(attack_target.position)
		attack_timer = 100

func strike(pos):
	var p = weapon.get_projectile()
	var projectile = Projectile.new("", "", p._speed, p._rotating,
			p._dmg, p._inaccuracy, p._sprite_name, false, Vector2.ZERO, Vector2.ZERO)
	get_parent().add_child(projectile)
	projectile.fire((pos-position).normalized(), position)

func get_target():
	return _target

func add_health(amount):
	if (_health + amount) <= 100.0:
		_health += amount
	else:
		_health = 100.0
	if(amount < 0):
		player_hurt.play()
	if _health <= 0:
		player_dead.play()
		# delete fella
		pass
