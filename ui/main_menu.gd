extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if(OS.has_feature("web")):
		$VBoxContainer/VBoxContainer/Quit.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_pressed():
	$AudioStreamPlayer.play()
	get_tree().change_scene("res://levels/level_1.tscn")


func _on_Credits_pressed():
	$AudioStreamPlayer.play()
	get_tree().change_scene("res://ui/credits.tscn")


func _on_Quit_pressed():
	$AudioStreamPlayer.play()
	get_tree().quit()


func _on_Level_Select_pressed():
	$AudioStreamPlayer.play()
	get_tree().change_scene("res://ui/level_selector.tscn")
