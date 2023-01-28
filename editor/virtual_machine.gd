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

var _labels = []
var _current_position = 0

var variables = []


func _init():
	variables.push_back({"name": "x", "value": 0, "type": "special"})
	variables.push_back({"name": "y", "value": 0, "type": "special"})
	variables.push_back({"name": "cnt", "value": 0, "type": "integer"})
	variables.push_back({"name": "str", "value": "", "type": "string"})
	variables.push_back({"name": "int", "value": 0, "type": "integer"})

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func add_label(label_name, pos):
	if _find_label(label_name) == null:
		_labels.push_back({"name": label_name, "pos": pos})
	print(_labels)


func _find_label(label_name):
	for i in _labels.size():
		if _labels[i]["name"] == label_name:
			return _labels[i]


func _find_variable(var_name):
	for i in variables.size():
		if variables[i]["name"] == var_name:
			return variables[i]


func _increase(var_name):
	var variable = _find_variable(var_name)
	variable["value"] += 1


func _decrease(var_name):
	var variable = _find_variable(var_name)
	variable["value"] -= 1


func _reset():
	variables[2] = 0


func _store(value, arg1):
	pass


func _emit():
	pass


func _jump(command):
	pass


func execute(command, arg1, arg2, arg3):
	if command == "inc":
		_increase(arg1)
	elif command == "dec":
		_decrease(arg1)
	elif command == "rst":
		_reset()
	elif command == "stor":
		_store()
	elif command == "emit":
		pass
	elif command == "jeq":
		pass
	elif command == "jlt":
		pass
	elif command == "jgt":
		pass
	elif command == "jmp":
		pass
