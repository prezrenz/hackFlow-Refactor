class_name VirtualMachine
extends Node


var _commands = [
	"inc",
	"dec",
	"rst",
	"stor",
	"emit",
	"jeq",
	"jlt",
	"jgt",
	"jmp",
]

var _labels = {}

var variables = []

var prev_x = 0
var prev_y = 0

var owned_by


func _init():
	variables.push_back({"name": "x", "value": 0, "type": "special"})
	variables.push_back({"name": "y", "value": 0, "type": "special"})
	variables.push_back({"name": "cnt", "value": 0, "type": "special"})
	variables.push_back({"name": "str", "value": "", "type": "string"})
	variables.push_back({"name": "int", "value": 0, "type": "integer"})

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func reset_state():
	prev_x = 0
	prev_y = 0
	
	_labels = {}
	
	for i in variables.size():
		variables[i]["value"] = 0


func add_label(label_name, pos):
#	if _find_label(label_name) == null:
#		_labels.push_back({"name": label_name, "pos": pos})
#	print(_labels)
	if !(_labels.has(label_name)):
		_labels.merge({label_name: pos})


func _find_label(label_name):
	if !_labels.has(label_name):
		return null
	else:
		return _labels[label_name]


func _find_variable(var_name):
	for i in variables.size():
		if variables[i]["name"] == var_name:
			return variables[i]
	
	return null


func _increase(var_name):
	var variable = _find_variable(var_name)
	
	if variable == null:
		# throw error variable not found
		owned_by.reset_level()
	
	# should throw error then reset
	if variable["type"] == "string":
		owned_by.reset_level()
	
	if variable["name"] == "x":
		prev_x = variable["value"]
	elif variable["name"] == "y":
		prev_y = variable["value"]
	
	variable["value"] += 1
	
	if (variable["name"] == "x") or (variable["name"] == "y"):
		owned_by.update_player()


func _decrease(var_name):
	var variable = _find_variable(var_name)
	
	if variable == null:
		# throw error variable not found
		owned_by.reset_level()
	
	# should throw error then reset
	if variable["type"] == "string":
		owned_by.reset_level()
	
	if variable["name"] == "x":
		prev_x = variable["value"]
	elif variable["name"] == "y":
		prev_y = variable["value"]
	
	variable["value"] -= 1
	
	if (variable["name"] == "x") or (variable["name"] == "y"):
		owned_by.update_player()


func _reset():
	variables[2] = 0


func _store(arg1):
	var data_to_store = owned_by.check_player_input()
	var data_store = _find_variable(arg1)
	
	if data_store == null:
		# throw error variable not found
		owned_by.reset_level()
	
	if data_to_store == null:
		# throw error, trying to store from empty tile
		owned_by.reset_level()
	
	# Should check if data types are same, throw error and reset if not
	if data_to_store[1] != data_store["type"]:
		owned_by.reset_level()
	
	data_store["value"] = data_to_store[0]


func _emit(arg1):
	var key_variable = _find_variable(arg1)
	
	if key_variable == null:
		# throw error variable not found
		owned_by.reset_level()
	
	var is_unlocked = owned_by.check_player_unlock(key_variable["value"])
	
	if !is_unlocked:
		# throw error reset level, wrong key
		owned_by.reset_level()


# too many if statements
func _jump(command, arg1, arg2, arg3):
	var test = _find_variable(arg1)
	
	if test == null:
		print("there")
		# throw error variable not found
		owned_by.reset_level()
	
	var jump_to
	if command != "jmp":
		jump_to = _find_label(arg3)
	else:
		jump_to = _find_label(arg1)
	
	if jump_to == null:
		# throw error
		print("here")
		owned_by.reset_level()
		return
	
	arg2 = int(arg2)
	
	if command == "jeq":
		if test["value"] == arg2:
			owned_by.set_editor_pos(jump_to)
	elif command == "jlt":
		if test["value"] < arg2:
			owned_by.set_editor_pos(jump_to)
	elif command == "jgt":
		if test["value"] > arg2:
			owned_by.set_editor_pos(jump_to)
	elif command == "jmp":
		owned_by.set_editor_pos(jump_to)


func execute(command, arg1, arg2, arg3):
	if command == "inc":
		_increase(arg1)
	elif command == "dec":
		_decrease(arg1)
	elif command == "rst":
		_reset()
	elif command == "stor":
		_store(arg1)
	elif command == "emit":
		_emit(arg1)
	elif command == "jeq":
		_jump(command, arg1, arg2, arg3)
	elif command == "jlt":
		_jump(command, arg1, arg2, arg3)
	elif command == "jgt":
		_jump(command, arg1, arg2, arg3)
	elif command == "jmp":
		_jump(command, arg1, arg2, arg3)
	else:
		# error cmd not found
		owned_by.reset_level()
