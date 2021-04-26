extends PanelContainer

var ACHIEVEMENT_DISPLAY_TIME = 2.5
var achievements = []
var berries_eaten = []
var display_queue = []


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	$Timer.set_wait_time(ACHIEVEMENT_DISPLAY_TIME)

func achievement(header : String, achievement_text : String):
	if achievements.has(header):
		return
	achievements.append(header)
	display_queue.append([header, achievement_text])
	next_text()
		

func berry(bry):
	if !berries_eaten.has(bry):
		berries_eaten.append(bry)
		
	if berries_eaten.size() == 2:
		achievement("Two berries eaten", "You are on your way to becoming a berry master")
	elif berries_eaten.size() == 3:
		achievement("Three berries eaten", "Further along the path to become a berry master, you are.")
	elif berries_eaten.size() == 5:
		achievement("Berry apprentice (5 berries)", "You are becoming recognized. \nBerry-eating dojos in the world are contacting you.")
	elif berries_eaten.size() == 7:
		achievement("Berry master (7 berries)", "You are being contacted by organizations who want you to\nbe in their ad campaigns")
	elif berries_eaten.size() == 10:
		achievement("Berry lord (10 berries)", "You are regarded as the most influental berry eater in \nthe world. Congratulations.")
	
	
func next_text():
	if display_queue.size() > 0 and $Timer.get_time_left() == 0:
		print(display_queue[0])
		$Label.text = display_queue[0][0].to_upper() + "\n" + display_queue[0][1]
		visible = true
		display_queue.remove(0)
		$Timer.start()
	if display_queue.size() == 0 and $Timer.get_time_left() == 0:
		visible = false


func _on_Timer_timeout():
	next_text()
