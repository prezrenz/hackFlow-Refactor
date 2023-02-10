extends AcceptDialog


var text : String setget set_text, get_text


# Called when the node enters the scene tree for the first time.
func _ready():
	get_ok().text = "Next Level"
	get_close_button().set_visible(false)
	
	add_button("Quit Game", true, "quit")


#func _process(delta):
#	pass


func get_text_label():
	return $VBoxContainer/Panel/RichTextLabel


func set_text(to_change: String):
	get_text_label().append_bbcode(to_change)


func get_text():
	return text


func _on_Outro_confirmed():
	owner.next_level()


func _on_Outro_custom_action(action):
	if action == "quit":
		get_tree().change_scene("res://ui/main_menu.tscn")

