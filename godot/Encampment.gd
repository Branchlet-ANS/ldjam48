extends Node2D

onready var sprite_campfire = preload("res://assets/programmer_campfire.png")
onready var sprite_bed = preload("res://assets/programmer_bed.png")
onready var sprite_spike = preload("res://assets/programmer_spike.png")

const DISTANCE_CAMPFIRE = 80
const DISTANCE_BED = 25
const DISTANCE_SPIKE = 45

const RAND_CAMPFIRE = 0.0
const RAND_BED = 0.0
const RAND_SPIKE = 0.0

var n = 10
var campfire_poss = []

func _ready():
	var n_campfire = ceil(float(n)/10)
	var n_bed = ceil(float(n)/2)
	var n_spike = int(float(n)*2)
	var angle_campfire = rand_range(0, PI)
	var angle_dif_spikes = 0.4
	
	for i in range(n_campfire):
		var campfire = Sprite.new()
		add_child(campfire)
		campfire.texture = sprite_campfire
		campfire.position = float(i) * float(DISTANCE_CAMPFIRE) * (1 + rand_range(-RAND_CAMPFIRE, RAND_CAMPFIRE)) * Vector2(sin(angle_campfire), cos(angle_campfire))
		campfire_poss.append(campfire.position)
	for i in range(n_bed):
		var bed = Sprite.new()
		add_child(bed)
		bed.texture = sprite_bed
		var my_campfire_pos = campfire_poss[floor(float(i)/(float(n)/2) * float(n_campfire))]
		var angle = 2*PI * (float(i)/float(n_bed) * float(n_campfire))
		bed.position = my_campfire_pos + float(DISTANCE_BED) * (1 + rand_range(-RAND_BED, RAND_BED)) * Vector2(sin(angle), cos(angle))
	for i in range(n_spike):
		var spike = Sprite.new()
		add_child(spike)
		spike.texture = sprite_spike
		var my_campfire_pos = campfire_poss[floor(float(i)/float(n_spike) * float(n_campfire))]
		var angle = 2*PI * (float(i)/float(n_spike) * float(n_campfire))
		print(abs(angle - angle_campfire))
		if(n_campfire) != 1:
			if(floor(float(i)/float(n_spike) * float(n_campfire)) == 0):
				if(abs(fmod(angle, 2*PI) - fmod(angle_campfire, 2*PI)) < angle_dif_spikes):
					spike.queue_free()
					continue
			elif(floor(float(i)/float(n_spike) * float(n_campfire)) == n_campfire-1):
				if(abs(fmod(angle, 2*PI) - fmod(angle_campfire, 2*PI) - PI) < angle_dif_spikes):
					spike.queue_free()
					continue			
			elif(abs(fmod(angle, PI) - fmod(angle_campfire, PI)) < angle_dif_spikes):
				spike.queue_free()
				continue
		spike.position = my_campfire_pos + float(DISTANCE_SPIKE) * (1 + rand_range(-RAND_SPIKE, RAND_SPIKE))* Vector2(sin(angle), cos(angle))
		

