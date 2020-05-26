extends Camera2D


export (float) var speed = 20
export (float) var panspeed = 10.0
export (float) var zoomspeed = 50.0
export (float) var zoommargin = 0.1
export (float) var zoomfactor = 1.0
export var zoom_min = 0.5
export var zoom_max = 2.0

export var margin_x = 200.0
export var margin_y = 100.0

var input = Vector2()
var zoompos = Vector2()
var mousepos = Vector2()
var mousepos_global = Vector2()


func _ready():
	position = Vector2(640, 360)
	pass


func _physics_process(delta):
	
	#smooth camera movement
	input.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	
	#position.y = lerp(position.y, position.y + input.y * speed * zoom.y, speed * delta)
	
	#zoom in
	if abs(zoompos.x - get_global_mouse_position().x) > zoommargin:
		zoomfactor = 1.0
	if abs(zoompos.y - get_global_mouse_position().y) > zoommargin:
		zoomfactor = 1.0
	
	var magnify = int(Input.is_action_pressed("zoom_out")) - int(Input.is_action_pressed("zoom_in"))
	
	if magnify != 0:
		zoomfactor += magnify * 0.01
		zoompos = get_global_mouse_position()
		
	zoom.x = lerp(zoom.x, zoom.x * zoomfactor, zoomspeed * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoomfactor, zoomspeed * delta)
	
	# clamps the zoom to 0.5x and 2x resolution
	zoom.x = clamp(zoom.x, zoom_min, zoom_max)
	zoom.y = clamp(zoom.y, zoom_min, zoom_max)
	
	
	if Input.is_action_pressed("move_margin"):
		# checks to see if mouse is close to margin of screen
		# going closer to the edge of the screen increases movement speed
		# X axis movement
		if mousepos.x < margin_x:
			position.x = lerp(position.x, position.x - abs(mousepos.x - margin_x)/margin_x * panspeed * speed * zoom.x, panspeed * delta)
		
		elif mousepos.x > OS.window_size.x - margin_x:
			position.x = lerp(position.x, position.x + abs(mousepos.x - OS.window_size.x + margin_x)/margin_x * panspeed * speed * zoom.x, panspeed * delta)
			
		# Y axis movement
		if mousepos.y < margin_y:
			position.y = lerp(position.y, position.y - abs(mousepos.y - margin_y)/margin_y * panspeed * speed * zoom.y, panspeed * delta)
		
		elif mousepos.y > OS.window_size.y - margin_y:
			position.y = lerp(position.y, position.y + abs(mousepos.y - OS.window_size.y + margin_y)/margin_y * panspeed * speed * zoom.y, panspeed * delta)

func _input(event):
	if event is InputEventMouse:
		mousepos = event.position
