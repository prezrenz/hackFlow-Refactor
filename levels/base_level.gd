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


func reset_level():
	virtual_machine.reset_state()
	editor.reset_state()
	
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
	
	var collisions = player.get_overlapping_areas()
	
	if check_tile(collisions[0]) == "padlock":
		# illegal move should reset game while also throw error
		reset_level()

