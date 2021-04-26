extends PanelContainer

var achievements = []
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func achievement(achievement_text : String):
	if achievements.has(achievement_text):
		return
	achievements.append(achievement_text)
	$Label.text = "Achievement!\n" + achievement_text
	visible = true
	
func _on_Timer_timeout():
	visible = false
