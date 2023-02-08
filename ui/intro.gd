extends Popup


var text : String setget set_text, get_text


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_ok():
	return $Panel/VBoxContainer/Button


func get_text_label():
	return $Panel/VBoxContainer/Panel/RichTextLabel


func set_text(to_change: String):
	get_text_label().set_bbcode(to_change)


func get_text():
	return text


func _on_Button_pressed():
	self.hide()
