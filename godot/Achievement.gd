extends PanelContainer

var ACHIEVEMENT_DISPLAY_TIME = 4
var timer : Timer = Timer.new()
var achievements = []

var display_queue = []


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	timer.connect("timeout" ,self, "_on_timer_timeout") 
	
	add_child(timer) #to process
	timer.set_wait_time(ACHIEVEMENT_DISPLAY_TIME)
	achievement("You wake up deep in the jungle", "all you can think of is that you need to find a way out")

func achievement(header : String, achievement_text : String):
	if achievements.has(header):
		return
	achievements.append(header)
	display_queue.append([header, achievement_text])
	if timer.get_time_left() == 0:
		next_text()

func next_text():
	if display_queue.size() > 0:
		visible = true
		$Label.text = display_queue[0][0].to_upper() + "\n" + display_queue[0][1]
		timer.start()
		display_queue.pop_front()
	else:
		visible = false


func _on_timer_timeout():
	next_text()
