extends Area2D


export(String, "string", "integer") var type = "string"
export(String) var key_str
export(int) var key_int


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("tiles")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
