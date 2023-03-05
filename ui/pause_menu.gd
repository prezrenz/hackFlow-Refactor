extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Resume_pressed():
	owner.play_sound("select")
	self.hide()


func _on_Quit_pressed():
	owner.play_sound("select")
	get_tree().change_scene("res://ui/main_menu.tscn")


func _on_Help_pressed():
	owner.play_sound("select")
	$Help.popup_centered()
