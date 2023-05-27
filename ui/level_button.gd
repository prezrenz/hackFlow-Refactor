extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_disabled(!Globals.levels_unlocked["level_" + self.text])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LevelButton_pressed():
	$AudioStreamPlayer.play()
	get_tree().change_scene("res://levels/level_" + self.text + ".tscn")
