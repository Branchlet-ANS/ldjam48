extends KinematicReal

class_name Character

enum STATE {
	idle,
	target,
	job,
	attack
}

var inventory : Inventory = Inventory.new()
var _state : int
var velocity : Vector2 = Vector2(0, 0)
var _target : Vector2 = Vector2(0, 0)
var speed : float = 100
var job : Real = null
var job_timer : int = 0
var interact_area : Area2D
var attack_timer : int = 0
var attack_target : KinematicReal
var attack_moving = false
var weapon : Weapon = null
var _health : float = 100.0

var player_step : AudioStreamPlayer2D
var step_pos : Vector2 = Vector2.ZERO
var step_dist : float = 10

func _init(id : String, name: String = "").(id, name):
	weapon = Weapon.new("", "", 10, 100, true, 200, "arrow", true, 0.7)
	pass

func _ready():
	set_sprite("characters/character.png")
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

	player_step = AudioStreamPlayer2D.new()
	add_child(player_step)
	var sfx = load("res://Assets/SFX/walk1.wav")
	player_step.set_stream(sfx)
	player_step.play()
	step_dist *= rand_range(0.8, 1.2)

func _process(_delta):
	if((position - step_pos).length() > 10):
		step_pos = position
		if(!player_step.playing):
			player_step.play()
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
		velocity = move_and_slide(velocity)
		if transform.origin.distance_to(_target) < speed * 8 * delta:
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

func _on_Area2D_body_entered(body):
	if body is Item:
		inventory.add(body)
		body.get_parent().remove_child(body)

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
		print(_health + amount)
		_health += amount
	else:
		_health = 100.0

	if _health <= 0:
		# delete fella
		pass
