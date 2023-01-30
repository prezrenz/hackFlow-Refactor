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


func update_player():
	var x = virtual_machine.variables[0]["value"]
	var y = virtual_machine.variables[1]["value"]
	player.move_player(x, y)

