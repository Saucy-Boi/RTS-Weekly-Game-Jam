extends KinematicBody2D
export (int) var hp = 100
export (int) var max_hp = 100
export (int) var speed = 100 
export (int) var target_radius = 50 # stop when this close to target

onready var box = $Box
onready var hp_bar = $HP_Bar
onready var collision = $CollisionShape2D

signal was_selected
signal was_deselected 

var target = null setget set_target
var selected = false setget set_selected
var vel = Vector2.ZERO

func set_selected(value):
	if selected != value:
		selected = value
		box.visible = value
		hp_bar.visible = value
		if selected:
			emit_signal("was_selected", self)
		
		else:
			emit_signal("was_deselected", self)

func set_target(value):
	target = value


func _ready():
	box.visible = false
	hp_bar.visible = false
	
	connect("was_selected", get_parent(), "select_unit")
	connect("was_deselected", get_parent(), "deselect_unit")
	
	hp_bar.rect_position.x = -(hp_bar.rect_size.x/2)
	hp_bar.rect_position.y = -(hp_bar.rect_size.x/2)

func _physics_process(delta):
	vel = Vector2.ZERO
	if target:
		vel.position.direction_to(target)


func _on_Unit_input_event(viewport, event, shape_idx):
	if event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			set_selected(!selected)
