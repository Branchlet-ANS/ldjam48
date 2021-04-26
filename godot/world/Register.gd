extends Node

class_name Register

func _ready():
	pass

func register_real(id, _name, sprite, corruption, interactable, object, subtype=""):
	return {
		"id": id,
		"name": _name,
		"sprite": sprite,
		"corruption": corruption,
		"interactable": interactable,
		"object": object,
		"subtype": subtype,
		"chance": 1
	}

func register_food_plant(id, _name, sprite, corruption, subtype="", chance=1, value=0):
	var dict = register_real(id, _name, sprite, corruption, true, FoodPlant)
	dict["subtype"] = subtype
	dict["chance"] = chance
	dict["value"] = value
	return dict

func register_weapon(id, _name, sprite, corruption, chance=1, value=0):
	var dict = register_real(id, _name, sprite, corruption, true, RoomWeapon, "weapon")
	dict["chance"] = chance
	dict["value"] = value
	return dict

func register_enemy(id, _name, sprite, corruption, resistance, sense_radius, attack_radius, power, chance=1):
	var dict = register_real(id, _name, sprite, corruption, false, Enemy, "enemy")
	dict["resistance"] = resistance
	dict["sense_radius"] = sense_radius
	dict["attack_radius"] = attack_radius
	dict["power"] = power
	dict["chance"] = chance
	return dict

## hello
func register_character(id, _name, sprite, corruption, health_min, health_max, weapons : Array, chance=1):
	var dict = register_real(id, _name, sprite, corruption, false, Character, "character")
	dict["health_min"] = health_min
	dict["health_max"] = health_max
	dict["weapons"] = weapons
	dict["chance"] = chance
	return dict


var objects_json =  [
	register_real("o:room_entrance", "Room Entrance", "blank_box.png", 0, true, RoomPortal),
	register_real("o:room_exit", "Room Exit", "blank_box.png", 0, true, RoomPortal),
	register_food_plant("o:wangu_berry", "Wangu", "items/wangu.png", 0, "berry", 0.8, 1),
	register_food_plant("o:blue_banana", "Blue Banana", "items/blue_banana.png", 3, "berry", 0.6, 2),
	register_food_plant("o:cherry_berry", "Cherry Berry", "items/cherry_berry.png", 0,"berry", 0.6, 3),
	register_food_plant("o:penis_berry", "Penis Berry", "items/penis_berry.png", 7, "berry", 0.6, -20),
	register_weapon("o:bow", "Bow", "items/bow.png", 1, 0.12),
	register_weapon("o:crossbow", "Crossbow", "items/crossbow.png", 3, 0.07),
	register_weapon("o:gun", "Gun", "items/gun.png", 7, 0.02),
	register_weapon("o:sword", "Sword", "items/sword.png", 1, 0.12),
	register_weapon("o:pike", "Pike", "items/pike.png", 3, 0.07),
	register_weapon("o:halberd", "Halberd", "items/halberd.png", 5, 0.03),
	register_real("o:grass", "Grass", "items/grass.png", 0, false, Real, "foliage"),
	register_real("o:haygrass", "Haygrass", "items/haygrass.png", 1, false, Real, "foliage"),
	register_real("o:rock", "Rock", "items/rock.png", 1, true, StaticReal, "decoration"),
	register_real("o:skeleton1", "Skeleton1", "terrain/dead party/skeleton_man.png", 1, true, StaticReal, "decoration"),
	register_real("o:skeleton2", "Skeleton2", "terrain/dead party/skeleton_man2.png", 1, true, StaticReal, "decoration"),
	register_real("o:skeleton3", "Skeleton3", "terrain/dead party/skeleton_man3.png", 1, true, StaticReal, "decoration"),
	register_real("o:skeleton4", "Skeleton4", "terrain/dead party/skeleton_horse.png", 1, true, StaticReal, "decoration"),
	register_real("o:cart", "Cart", "terrain/dead party/cart.png", 1, true, StaticReal, "decoration"),
	register_real("o:tree", "Tree", "terrain/tree.png", 0, true, StaticReal, "decoration"),
	register_enemy("o:monkey", "Monkey", "animals/monkey.png", 3, 2, 64, 8, 10, 1),
	register_enemy("o:skeleton_horse", "Skeleton Horse", "terrain/dead party/skeleton_horse.png",\
	 3, 1, 128, 32, 25, 0.1),
	register_character("o:scruffy_character", "Scruffy Character", "characters/character_scruffy.png", \
	0, 7, 23, ["Bow"], 0.1)
]

func get_objects_by(attribute, terms):
	# dirty code to allow both singular and multiple input
	if !(terms is Array):
		terms = [terms]
	for i in range(len(terms)):
		terms[i] = str(terms[i])


	var objects = []
	for object in objects_json:
		if object.has(attribute):
			if terms.has(str(object[attribute])):
				objects.append(object)
	return objects

func less_corrupt_than(corruption : float, list : Array):
	var return_list = []
	for object in list:
		if object["corruption"] <= corruption:
			return_list.append(object)
	return return_list

func get_object(id):
	for object in objects_json:
		if object["id"] == id:
			return object
