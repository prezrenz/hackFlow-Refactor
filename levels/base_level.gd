extends TileMap

export (String,MULTILINE) var intro
export (String,MULTILINE) var outro


onready var virtual_machine = load("res://editor/virtual_machine.gd").new()

onready var editor = $UI/Editor
onready var variables_ui = $UI/Variables
onready var error = $UI/ErrorPopup

onready var player = $Player
onready var camera = $Camera


var score = 5000
var disks = 0
var won = false


func _ready():
	Globals.levels_unlocked[self.get_name()] = true
	Globals.save_levels_unlocked()
	# Workaround: instanced scripts don't have a ref to scene root like owner since
	# they aren't nodes, so I store ref to scene root to a variable in virtual_machine
	virtual_machine.owned_by = self
	
	editor.set_visible(true)
	variables_ui.set_visible(true)
	
	init_variables_ui()
	show_intro()


func _process(_delta):
	process_variables_ui()
	
	check_player_collision()


func reset_level():
	virtual_machine.reset_state()
	editor.reset_state()
	get_tree().call_group("tiles", "show")
	get_tree().call_group("scores", "reset")
	score = 0
	
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
			throw_error("move")
		elif (check_tile(collisions[0]) == "score"):
			if !collisions[0].taken:
				score += 800
				disks += 1
			collisions[0].hide()
			collisions[0].taken = true
		elif (check_tile(collisions[0]) == "teleport"):
			virtual_machine.set_variable("x", collisions[0].dest.x)
			virtual_machine.set_variable("y", collisions[0].dest.y)
			player.move_player(collisions[0].dest.x, collisions[0].dest.y)
		elif (check_tile(collisions[0]) == "exit"):
			if won == true:
				return
			else:
				won = true
				show_outro() # end level tally score


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
					if str(key) == collisions[i].key_str: # str(key) is another hack. revise this shit my god
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
		throw_error("move")
		return
	
	player.move_player(x, y)


func throw_error(type):
	if type == "end":
		play_sound("fail")
	else:
		play_sound("error")
	
	error.set_error_msg(editor.get_current_line(), editor.current_position, type)
	error.popup_centered()


func show_intro():
	$UI/Intro.set_text(intro)
	$UI/Intro.popup_centered()


func calculate_score():
	var lines_of_code = editor.get_loc()
	score = 5000
	$UI/Outro.set_text("\n[center][color=yellow][shake rate=10 level=6]---YOUR SCORE---[/shake][/color]\n" 
						+ "BASE SCORE: 5000\n" 
						+ "LINES OF CODE: %d * 50 = -%d\n" % [lines_of_code, lines_of_code * 50]
						+ "DISKS: %d * 800 = +%d\n" % [disks, disks * 800]
						+ "FINAL SCORE: %d[/center]" % (score - (lines_of_code * 50)))


func show_outro():
	Globals.levels_unlocked["level_" + str(int(self.get_name())+1)] = true
	Globals.save_levels_unlocked()
	print("level_" + str(int(self.get_name())))
	play_sound("win")
	$UI/Outro.set_text(outro)
	calculate_score()
	# I don't know why, but without resetting the game
	# you can't click buttons on Outro at all, won't
	# focus, keeps unfocusing. Without this you need
	# to wait for the Editor Timer to end and reset the level,
	# which happens under unknown circumstances at random times
	# each run. My guess is the Editor node _input method
	# is gobbling up the mouse inputs. Or something dumb.
	reset_level()
	$UI/Outro.popup_centered()


func next_level():
	var current = int(get_tree().current_scene.name)
	var next
	
	if current == 15:
		next = "res://ui/credits.tscn"
	else:
		next = "res://levels/level_" + str(current + 1) + ".tscn"
	
	get_tree().change_scene(next)


func _on_PauseGame_pressed():
	play_sound("select")
	$UI/PauseMenu.popup_centered()


func _on_ShowEditor_pressed():
	play_sound("select")
	if editor.visible == true:
		editor.visible = false
	elif editor.visible == false:
		editor.visible = true


func _on_ShowHideData_pressed():
	play_sound("select")
	get_tree().call_group("data tiles", "toggle_data")


func _on_ShowVariables_pressed():
	play_sound("select")
	if variables_ui.visible == true:
		variables_ui.visible = false
	elif variables_ui.visible == false:
		variables_ui.visible = true


func _on_ShowIntro_pressed():
	play_sound("select")
	$UI/Intro.popup_centered()


func play_sound(snd: String):
	if snd == "win":
		$Win.play()
	elif snd == "fail":
		$Fail.play()
	elif snd == "error":
		$Error.play()
	elif snd == "select":
		$Select.play()
