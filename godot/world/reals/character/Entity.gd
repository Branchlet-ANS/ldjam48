extends KinematicReal

class_name Entity

enum STATE {
	idle,
	target,
	job,
	attack
}

var _state : int
var velocity : Vector2 = Vector2.ZERO
var _target : Vector2 = Vector2.ZERO
var speed_max : float = 80
var acceleration : float = 20
var damp = 0.8
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
var _resistance : float = 1.0
var melee_in_range : Array = []
var _power = 2

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
	speed_max = 50
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
			attack_target = null
		if is_instance_valid(job):
			set_target(job.transform.origin)
	if get_state() == STATE.job:
		perform_job()
	if get_state() == STATE.attack:
		attack_cycle(_delta)

func _physics_process(delta):
	if get_state() == STATE.target:
		var velocity_prev = velocity
		move_towards(_target)
		if transform.origin.distance_to(_target) < speed_max * delta:
			if is_instance_valid(job) and job.transform.origin == get_target():
				set_state(STATE.job)
			else:
				set_state(STATE.idle)
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
	velocity = move_and_slide(velocity)
	velocity *= damp

func move_towards(pos):
	if velocity.length() < speed_max:
		var direction = transform.origin.direction_to(pos)
		velocity += direction * acceleration
		
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
	if job == null or !is_instance_valid(job):
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
	if !is_instance_valid(at):
		return
	if(weapon.get_has_projectile()):
		# skytelyd
		if(weapon.get_weapon_name() == "Gun"):
			EffectsManager.play_video("flash", get_parent().get_parent(), position)
		var p = weapon.get_projectile()
		var projectile = Projectile.new("", "", p._speed, p._rotating,
				p._dmg, p._inaccuracy, p._sprite_name, false, Vector2.ZERO, Vector2.ZERO)
		get_parent().add_child(projectile)
		projectile.fire((at.position-position).normalized(), position)
	else:
		EffectsManager.play_video("slash", get_parent().get_parent(), position)
		for entity in melee_in_range:
			entity.add_health(-weapon.get_dmg())


func get_target():
	return _target

func add_health(amount):
	if (_health + amount) <= 100.0:
		_health += amount * 1.0/_resistance
	else:
		_health = 100.0
	if(_health <= 0):
		EffectsManager.play_sound("dead", get_parent().get_parent(), position)
	elif(amount < 0):
		EffectsManager.play_sound("hurt", get_parent().get_parent(), position)


func _on_Area2D_body_entered(body):
	if	is_instance_valid(body):
		if body is Projectile:
			if (!body.get_owner() == self):
				add_health(-body.get_damage())
				body.queue_free()
				EffectsManager.play_video("splash", get_parent().get_parent(), position)

func _on_melee_Area2D_body_entered(body):
	pass

func _on_melee_Area2D_body_exited(body):
	pass
