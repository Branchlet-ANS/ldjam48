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
var speed_max : float = 75
var acceleration : float = 20
var damp = 0.8
var job : Real = null
var job_timer : float = 0
var interact_area : Area2D
var melee_area : Area2D
var attack_timer : float = 0
var attack_target : KinematicReal
var attack_moving : bool = false
var weapon_list : Dictionary = {}
var weapon : Weapon = null
var _health : float = 100.0
var _resistance : float = 1.0
var melee_in_range : Array = []
var _power = 2
var last_anim : String = ""
var _sprite


#Construct item (id : String, name: String, dmg : float = 10,
#		attack_timer : float = 100,
#		has_projectile : bool = false,
#		projectile_speed : float = 200,
#		projectile_sprite_name : String = "bullet",
#		projectile_rotating : bool = false,
#		projectile_inaccuracy : float = 0,
#		desired_distance : float = 100,
#		weapon_name : String = "")

func _init(id : String, name: String = "").(id, name):
	weapon_list["Bow"] = Weapon.new("", "", 5, 1, true, 200, "arrow", true, 0.3, 50, "Bow")
	weapon_list["Crossbow"] = Weapon.new("", "", 20, 1.5, true, 300, "arrow", true, 0.05, 50, "Crossbow")
	weapon_list["Gun"] = Weapon.new("", "", 40, 2, true, 400, "bullet", false, 0.7, 50, "Gun")
	weapon_list["Sword"] = Weapon.new("", "", 5, 0.6, false, 0, "", false, 0, 10, "Sword")
	weapon_list["Pike"] = Weapon.new("", "", 13, 0.7, false, 0, "", false, 0, 25, "Pike")
	weapon_list["Halberd"] = Weapon.new("", "", 27, 1, false, 0, "", false, 0, 20, "Halberd")
	weapon_list["Fists"] = Weapon.new("", "", 2, 0.6, false, 0, "", false, 0, 10, "Fists")
	pass

func _ready():
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
		perform_job(_delta)

func _physics_process(delta):
	if get_state() == STATE.target:
		var velocity_prev = velocity
		move_towards(_target)
		
		var target_width = 0
		if is_instance_valid(job):
			if job is StaticReal:
				target_width = 2*(job.collision_shape.shape.extents.length() + \
				self.collision_shape.shape.extents.length())
			else:
				target_width = self.collision_shape.shape.extents.length()
		
		if transform.origin.distance_to(_target) <= velocity.length() * delta + target_width:
			if is_instance_valid(job) and job.transform.origin == get_target():
				set_state(STATE.job)
			else:
				set_state(STATE.idle)
	
	velocity = move_and_slide(velocity)
	velocity *= damp

func set_sprite(spriteframes):
	sprite.frames = load("res://assets/" + spriteframes)
	sprite.set_position(sprite.get_position() + sprite_offset)
	
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
		job_timer = 0.5
	elif state == STATE.attack:
		attack_timer = 1

func set_target(target):
	_target = target
	set_state(STATE.target)

func perform_job(delta):
	if job == null or !is_instance_valid(job):
		set_state(STATE.idle)
		return
	job_timer -= delta
	if job_timer <= 0:
		job.interact(self)
		job = null
		set_state(STATE.idle)

func strike(at):
	if !is_instance_valid(at):
		return
	if(weapon.get_has_projectile()):
		# skytelyd
		if(weapon.get_weapon_name() == "Gun"):
			EffectsManager.play_video("flash", get_parent().get_parent(), position)
			EffectsManager.play_sound("gun", get_parent().get_parent(), position)
		if(weapon.get_weapon_name() == "Bow" || weapon.get_weapon_name() == "Crossbow"):
			EffectsManager.play_sound("bow", get_parent().get_parent(), position)
		var p = weapon.get_projectile()
		var projectile = Projectile.new("", "", p._speed, p._rotating,
				p._dmg, p._inaccuracy, p._sprite_name, false, Vector2.ZERO, Vector2.ZERO)
		get_parent().add_child(projectile)
		projectile.fire((at.position-position).normalized(), position)
	else:
		EffectsManager.play_sound("hit_sword2", get_parent().get_parent(), at.position)
		EffectsManager.play_video("slash", get_parent().get_parent(), at.position)
		for entity in melee_in_range:
			entity.add_health(-weapon.get_dmg())


func get_target():
	return _target

func add_health(amount):
	if (_health + amount) <= 100.0:
		_health += amount * 1.0/_resistance
	else:
		_health = 100.0


func _on_Area2D_body_entered(body):
	if	is_instance_valid(body):
		if body is Projectile:
			if (!body.get_owner() == self):
				add_health(-body.get_damage())
				EffectsManager.play_video("splash", get_parent().get_parent(), position)
				body.queue_free()

func _on_melee_Area2D_body_entered(body):
	pass

func _on_melee_Area2D_body_exited(body):
	pass
