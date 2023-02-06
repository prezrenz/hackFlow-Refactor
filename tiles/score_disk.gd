extends Area2D


# another fucking hack, fix that shit there has to be a better way
var taken = false


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("tiles")
	add_to_group("scores")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func reset():
	taken = false
