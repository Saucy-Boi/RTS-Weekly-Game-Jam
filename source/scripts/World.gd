extends Node2D

var dragging = false # are we dragging the mouse?
var selected = [] # array to hold selected units
var drag_start = Vector2.ZERO # location of drag start
var select_rect = RectangleShape2D.new() # collision of drag box

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			# only start drag if there is no selection
			if selected.size() == 0:
				dragging = true
				drag_start = event.position
			
			else:
				# if there is a selection, give it the target
				for item in selected:
					item.collider.target = event.position
					item.collider.selected = false
				selected = []
				
		elif dragging:
			# button released while dragging
			dragging = false
			# changes box shaped based off mouse pos
			update()
			var drag_end = event.position
			select_rect.extents = (drag_end - drag_start) / 2
			var space = get_world_2d().direct_space_state
			var query = Physics2DShapeQueryParameters.new()
			query.set_shape(select_rect)
			query.transform = Transform2D(0, (drag_end + drag_start) / 2)
			# if collision with unit occurs an array of dicts is created
			selected = space.intersect_shape(query)
			for item in selected:
				item.collider.selected = true
		
	if event is InputEventMouseMotion and dragging:
		update()

# draws the outline rect of the mouse drag
func draw():
	draw_line(Vector2(0,0), Vector2(-150, -50), Color(255, 0, 0), 4, false)
	if dragging:
		print("dragging")
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start), Color(0.5, 0.5, 0.5, 0.5), false)
