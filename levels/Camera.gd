extends Camera2D


var zoom_max = 2
var zoom_min = 0.4
var zoom_step = 0.1
var dragging = false


func _ready():
	set_camera_limits()

func _input(event):
	if(event is InputEventMouseButton):
		if(event.is_action_pressed("view_pan_mouse")):
			dragging = true
		elif(event.is_action_released("view_pan_mouse")):
			dragging = false
		if(event.is_action_pressed("view_zoom_in")):
			zoom -= Vector2(zoom_step, zoom_step)
			zoom.x = clamp(zoom.x, zoom_min, zoom_max)
			zoom.y = clamp(zoom.y, zoom_min, zoom_max)
		if(event.is_action_pressed("view_zoom_out")):
			zoom += Vector2(zoom_step, zoom_step)
			zoom.x = clamp(zoom.x, zoom_min, zoom_max)
			zoom.y = clamp(zoom.y, zoom_min, zoom_max)
	if event is InputEventMouseMotion and dragging:
		position -= event.relative


func set_camera_limits():
	var map_limits = get_parent().get_used_rect()
	var map_cellsize = get_parent().cell_size
	self.limit_left = map_limits.position.x * map_cellsize.x - 144
	self.limit_right = map_limits.end.x * map_cellsize.x + 144
	self.limit_top = map_limits.position.y * map_cellsize.y - 144
	self.limit_bottom = map_limits.end.y * map_cellsize.y + 144


