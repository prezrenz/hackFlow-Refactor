extends Area2D


export(String, "string", "integer") var type = "string"
export(String) var key_str
export(int) var key_int


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("tiles")
	add_to_group("data tiles")
	
	if type == "string":
		$Data/Label.set_text("key: " + key_str)
	elif type == "integer":
		$Data/Label.set_text("key: " + key_int)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func toggle_data():
	if $Data.visible == true:
		$Data.visible = false
	elif $Data.visible == false:
		$Data.visible = true
