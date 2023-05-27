extends Node


var levels_unlocked = {
	"level_1": true,
	"level_2": false,
	"level_3": false,
	"level_4": false,
	"level_5": false,
	"level_6": false,
	"level_7": false,
	"level_8": false,
	"level_9": false,
	"level_10": false,
	"level_11": false,
	"level_12": false,
	"level_13": false,
	"level_14": false,
	"level_15": false,
}


# Called when the node enters the scene tree for the first time.
func _ready():
	var save = File.new()
	print(save.file_exists("user://levels_unlocked.sav"))
	if(!save.file_exists("user://levels_unlocked.sav")):
		save_levels_unlocked()
	else:
		load_levels_unlocked()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func unlock_level(level: int):
#	levels_unlocked["level_" + str(level)]


func save_levels_unlocked():
	var sav = File.new()
	sav.open("user://levels_unlocked.sav", File.WRITE)
	sav.store_string(var2str(levels_unlocked))
	sav.close()


func load_levels_unlocked():
	var sav = File.new()
	sav.open("user://levels_unlocked.sav", File.READ)
	levels_unlocked = str2var(sav.get_as_text())
	sav.close()
