extends PopupPanel


onready var current_position = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _input(event):
	if event is InputEventKey:
		if event.pressed:
			pass


func reset_state():
	current_position = 0
	$VContainer/TextEdit.cursor_set_line(0)

func get_current_line():
	return $VContainer/TextEdit.get_line(current_position - 1)

func _on_Step_button_up():
	if current_position > $VContainer/TextEdit.get_line_count() - 1:
		# Should throw error then reset level, you failed
		owner.throw_error("end")
		return
	
	for i in $VContainer/TextEdit.get_line_count():		
		var line = $VContainer/TextEdit.get_line(i)
		if ';' in line:
			owner.virtual_machine.add_label(line.get_slice(";", 1), i)
	
	var line = $VContainer/TextEdit.get_line(current_position)
	current_position += 1
	
	if ';' in line:
		return
	
	$VContainer/TextEdit.cursor_set_line(current_position - 1)
	
	var command = line.get_slice(" ", 0)
	var arg1 = line.get_slice(" ", 1)
	var arg2 = line.get_slice(" ", 2)
	var arg3 = line.get_slice(" ", 3)
	
	owner.virtual_machine.execute(command, arg1, arg2, arg3)


func _on_TextEdit_text_changed():
	$Timer.start()


func _on_Timer_timeout():
	owner.reset_level()
