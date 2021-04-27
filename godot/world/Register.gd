extends Node

class_name Register

func _ready():
	pass

func register_real(id, _name, sprite, corruption, interactable, object, subtype="", offset:Vector2=Vector2.ZERO):
	return {
		"id": id,
		"name": _name,
		"sprite": sprite,
		"corruption": corruption,
		"interactable": interactable,
		"object": object,
		"subtype": subtype,
		"chance": 1,
		"offset": offset
	}

func register_food_plant(id, _name, sprite, corruption, subtype="", chance=1, value=0, offset:Vector2=Vector2.ZERO):
	var dict = register_real(id, _name, sprite, corruption, true, FoodPlant)
	dict["subtype"] = subtype
	dict["chance"] = chance
	dict["value"] = value
	dict["offset"] = offset
	return dict

func register_weapon(id, _name, sprite, corruption, chance=1, value=0, offset:Vector2=Vector2.ZERO):
	var dict = register_real(id, _name, sprite, corruption, true, RoomWeapon, "weapon")
	dict["chance"] = chance
	dict["value"] = value
	dict["offset"] = offset
	return dict

func register_enemy(id, _name, sprite, corruption, resistance, sense_radius, attack_radius, power, speed, chance=1, offset:Vector2=Vector2.ZERO):
	var dict = register_real(id, _name, sprite, corruption, false, Enemy, "enemy")
	dict["resistance"] = resistance
	dict["sense_radius"] = sense_radius
	dict["attack_radius"] = attack_radius
	dict["power"] = power
	dict["chance"] = chance
	dict["offset"] = offset
	dict["speed"] = speed
	return dict

## hello
func register_character(id, _name, sprite, corruption, health_min, health_max, weapons : Array, chance=1, offset:Vector2=Vector2.ZERO):
	var dict = register_real(id, _name, sprite, corruption, false, Character, "character")
	dict["health_min"] = health_min
	dict["health_max"] = health_max
	dict["weapons"] = weapons
	dict["chance"] = chance
	dict["offset"] = offset
	return dict


var objects_json =  [
	register_real("o:room_entrance", "Room Entrance", "entrance.png", 0, true, RoomPortal),
	register_real("o:room_exit", "Room Exit", "exit.png", 0, true, RoomPortal),

	register_food_plant("o:wangu_berry", "Wangu", "bushes/wangu.png", 0, "berry", 0.8, 5),
	register_food_plant("o:cherry_berry", "Cherry Berry", "bushes/cherry_berry.png", 0,"berry", 0.6, -5),
	register_food_plant("o:blue_banana", "Blue Banana", "bushes/blue_banana.png", 1, "berry", 0.6, 7),
	register_food_plant("o:penis_berry", "Penis Berry", "bushes/penis_berry.png", 2, "berry", 0.6, -25),
	register_food_plant("o:bee_berry", "Bee Berry", "bushes/bee_berry.png", 3, "berry", 0.4, 10),
	register_food_plant("o:zip_berry", "Zip Berry", "bushes/zip_berry.png", 3, "berry", 0.5, -100),

	register_food_plant("o:blue_wangu", "Blue Wangu", "bushes/blue_wangu.png", 4, "berry", 0.8, -100),
	register_food_plant("o:red_banana", "Red Banana", "bushes/red_banana.png", 5, "berry", 0.8, 15),

	register_food_plant("o:wasp_berry", "Wasp Berry", "bushes/wasp_berry.png", 6, "berry", 0.5, -100),
	register_food_plant("o:bat_berry", "Bat Berry", "bushes/wasp_berry.png", 7, "berry", 0.3, 25),

	register_food_plant("o:purple_wangu", "Purple Wangu", "bushes/purple_wangu.png", 9, "berry", 0.8, 35),
	register_food_plant("o:prickled_wangu", "Prickled Wangu", "bushes/prickled_wangu.png", 10, "berry", 0.8, -120),
	register_food_plant("o:purple_cherry", "Purple Cherry", "bushes/purple_cherry.png", 9, "berry", 0.45, 30),

	register_food_plant("o:thorn_berry", "Thorn Berry", "bushes/thorn_berry.png", 10, "berry", 0.02, 200),


	register_weapon("o:bow", "Bow", "items/bow.png", 1, 0.15),
	register_weapon("o:crossbow", "Crossbow", "items/crossbow.png", 3, 0.09),
	register_weapon("o:gun", "Gun", "items/gun.png", 0, 0.03),
	register_weapon("o:sword", "Sword", "items/sword.png", 1, 0.17),
	register_weapon("o:pike", "Pike", "items/pike.png", 3, 0.07),
	register_weapon("o:halberd", "Halberd", "items/halberd.png", 5, 0.06),

	register_real("o:grass", "Grass", "items/grass.png", 0, false, Real, "foliage"),
	register_real("o:haygrass", "Haygrass", "items/haygrass.png", 1, false, Real, "foliage"),
	register_real("o:rock", "Rock", "items/rock.png", 1, true, StaticReal, "decoration"),
	register_real("o:skeleton1", "Skeleton1", "terrain/dead party/skeleton_man.png", 1, false, StaticReal, "decoration"),
	register_real("o:skeleton2", "Skeleton2", "terrain/dead party/skeleton_man2.png", 1, false, StaticReal, "decoration"),
	register_real("o:skeleton3", "Skeleton3", "terrain/dead party/skeleton_man3.png", 1, false, StaticReal, "decoration"),
	register_real("o:skeleton4", "Skeleton4", "terrain/dead party/skeleton_horse.png", 1, false, StaticReal, "decoration"),
	register_real("o:cart", "Cart", "terrain/dead party/cart.png", 1, false, StaticReal, "decoration"),
	register_real("o:tree", "Tree", "terrain/tree.png", 0, true, StaticReal, "decoration", Vector2.UP*8),
	register_real("o:place_characters_here", "", "", 0, false, Real),

	#register_enemy(id, _name, sprite, corruption, resistance, sense_radius, attack_radius, power, speed, chance=1, offset:Vector2=Vector2.ZERO):
	register_enemy("o:monkey", "Monkey", "animals/monkey/monkey_anim.tres", 0, 2, 64, 8, 10, 45, 0.4),
	register_enemy("o:mini_monkey", "Mini Monkey", "animals/monkey_mini/monkey_mini_anim.tres", 0, 2, 64, 8, 10, 45, 0.4),
	register_enemy("o:bird_green", "Green Bird", "animals/bird/bird_anim_green.tres", 0, 2, 64, 8, 10, 45, 0.4),
	register_enemy("o:bird_red", "Red Bird", "animals/bird/bird_anim_red.tres", 0, 2, 64, 8, 10, 45, 0.4),
	register_enemy("o:bird_blue", "Blue Bird", "animals/bird/bird_anim_blue.tres", 0, 2, 64, 8, 10, 45, 0.4),
	register_enemy("o:bird_pink", "Pink Bird", "animals/bird/bird_anim_pink.tres", 0, 2, 64, 8, 10, 45, 0.4),

	register_character("o:basic_character", "Basic Character", "characters/char_basic_anim.tres", \
	1, 1, 50, ["Bow", "Fists", "Fists", "Fists", "Fists", "Sword"], 0.13),

	register_character("o:gentleman", "Gentleman", "characters/char_shirt_anim.tres", \
	1, 30, 40, ["Fists"], 0.11),

	register_character("o:novice_character", "Novice Character", "characters/char_basic_anim.tres", \
	4, 1, 50, ["Bow", "Sword", "Pike", "Fists"], 0.17),

	register_character("o:gentleman_gun", "Gentleman with gun", "characters/char_shirt_anim.tres", \
	5, 1, 5, ["Gun"], 0.05),



	register_character("o:armored", "Armored Fella", "characters/char_armor_anim.tres", \
	5, 20, 60, ["Crossbow", "Sword", "Fists", "Fists"], 0.09),

	register_character("o:armored_halberd", "Armored Fella with halberd", "characters/char_armor_anim.tres", \
	7, 60, 80, ["Halberd"], 0.06),

	register_character("o:armored_gun", "Armored Fella with gun", "characters/char_armor_anim.tres", \
	8, 100, 100, ["Gun"], 0.01)
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
