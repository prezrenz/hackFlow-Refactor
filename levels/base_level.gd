extends TileMap

export (String,MULTILINE) var intro
export (String,MULTILINE) var outro


onready var virtual_machine = load("res://editor/virtual_machine.gd").new()


func _ready():
	$UI/Editor.popup()
	
	


#func _process(delta):
#	pass

