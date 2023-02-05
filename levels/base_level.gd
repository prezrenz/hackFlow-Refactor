extends TileMap

export (String,MULTILINE) var intro
export (String,MULTILINE) var outro


onready var virtual_machine = load("res://editor/virtual_machine.gd").new()

onready var editor = $UI/Editor
onready var variables_ui = $UI/Variables

onready var player = $Player
onready var camera = $Camera


func _ready():
	# Workaround: instanced scripts don't have a ref to scene root like owner since
	# they aren't nodes, so I store ref to scene root to a variable in virtual_machine
	virtual_machine.owned_by = self
	
	editor.set_visible(true)
	variables_ui.set_visible(true)
	
	init_variables_ui()


func _process(delta):
	process_variables_ui()
	
	check_player_collision()


func reset_level():
	virtual_machine.reset_state()
	editor.reset_state()
	get_tree().call_group("tiles", "show")
	
	player.move_player(0, 0)


func init_variables_ui():
	for i in virtual_machine.variables.size():
		var nam = Label.new()
		var val = Label.new()
		
		nam.set_text(virtual_machine.variables[i]["name"])
		val.set_text(str(virtual_machine.variables[i]["value"]))
		
		nam.set_align(1)
		val.set_align(1)
		
		variables_ui.valLabels.merge({virtual_machine.variables[i]["name"]: val})
		
		variables_ui.nameList.add_child(nam)
		variables_ui.valueList.add_child(val)


func process_variables_ui():
	for i in virtual_machine.variables.size():
		variables_ui.valLabels[virtual_machine.variables[i]["name"]].set_text(str(virtual_machine.variables[i]["value"]))


func set_editor_pos(pos):
	editor.current_position = pos


func check_tile(tile):
	if tile.get_filename() == "res://tiles/padlock.tscn":
		return  "padlock"
	elif tile.get_filename() == "res://tiles/input.tscn":
		return  "input"
	elif tile.get_filename() == "res://tiles/exit_network.tscn":
		return  "exit"
	elif tile.get_filename() == "res://tiles/score_disk.tscn":
		return  "score"
	elif tile.get_filename() == "res://tiles/teleport.tscn":
		return  "teleport"


func check_player_collision():
	var collisions = player.get_overlapping_areas()
	if !collisions.empty():
		# Looks bad, either use helper or another if statement
		# Technically a HACK way of solving this
		if (check_tile(collisions[0]) == "padlock") and (collisions[0].is_visible()):
			# illegal move should reset game while also throw error
			reset_level()


# Looks awful, merge somehow with above function, too many ifs
func check_player_input():
	var collisions = player.get_overlapping_areas()
	if !collisions.empty():
		if check_tile(collisions[0]) == "input":
			if collisions[0].type == "string":
				return [collisions[0].str_dat, "string"]
			else:
				return [collisions[0].int_dat, "integer"]
		else:
			return null


# Again, too many ifs, look for alternatives to it, use helper functions
# For the error checking, should return true or false
func check_player_unlock(key):
	var collisions = player.get_node("Directions").get_overlapping_areas()
	if !collisions.empty():
		for i in collisions.size():
			if check_tile(collisions[i]) == "padlock":
				if (collisions[i].type == "string"):
					if key == collisions[i].key_str:
						collisions[i].hide()
						return true
					else:
						return false
				else:
					if str(key) == str(collisions[i].key_int):
						collisions[i].hide()
						return true
					else:
						return false
	return true


func update_player():
	var x = virtual_machine.variables[0]["value"]
	var y = virtual_machine.variables[1]["value"]
	var prev_x = virtual_machine.prev_x
	var prev_y = virtual_machine.prev_y
	
	if (get_cell(x, y) == 1) or (get_cell(x, y) == INVALID_CELL):
		# throw error, don't move player, reset level on ok
		reset_level()
		return
	
	player.move_player(x, y)


func throw_error():
	pass
