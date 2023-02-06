extends AcceptDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_ok().text = "Reset Level"
	get_ok().set_text_align(Button.ALIGN_CENTER)
	get_close_button().visible = false
	get_label().set_align(Label.ALIGN_CENTER)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_error_msg(line, pos, type):
	
	var error_line = "In line %d: %s\n\n" % [pos, line]
	var error_desc
	
	if type == "variable":
		error_desc = "Variable not found, please verify the arguements...\n"
	elif type == "label":
		error_desc = "Label not found, please verify the arguements...\n"
	elif type == "data":
		error_desc = "Data not found, no Input Tile on current Tile...\n"
	elif type == "cmd":
		error_desc = "Command does not exist, please verify...\n"
	elif type == "type":
		error_desc = "Variable Types do not match, please verify the arguements...\n"
	elif type == "key":
		error_desc = "Invalid Key, failed to unlock...\n"
	elif type == "move":
		error_desc = "Illegal move, you tried to move to a null tile or locked tile...\n"
	elif type == "end":
		error_desc = "End of program, you failed to reach the exit.\nPlease try again...\n"
	else:
		error_desc = "General Error, please notify the Developer...\n"
	
	set_text(error_line + error_desc)


func _on_ErrorPopup_confirmed():
	owner.reset_level()
