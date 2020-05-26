extends Node2D

var selected_units = []
var buttons = []

onready var button = preload("res://source/scenes/Button.tscn")
onready var battle_ui = $Battle_UI/Base

func select_unit(unit):
	if not selected_units.has(unit):
		selected_units.append(unit)
		print("selected %s" % unit.name)
		create_buttons()

func deselect_unit(unit):
	if not selected_units.has(unit):
		selected_units.erase(unit)
		print("deselected %s" % unit.name)
		create_buttons()


func create_buttons():
	delete_buttons()
	# if unit does not have a button, create one
	for unit in selected_units:
		if not buttons.has(unit.name):
			var but = button.instance()
			but.connect_me(self, unit.name)
			but.rect_position = Vector2(buttons.size() * 64 + 32, -battle_ui.get_node("NinePatchRect").rect_size.y / 2 - 32 )
			battle_ui.add_child(but)
			buttons.append(but.name)


func delete_buttons():
	# removes uneeded buttons
	for but in buttons:
		if battle_ui.has_node(but):
			var b = battle_ui.get_node(but)
			b.queue_free()
			battle_ui.remove_child(b)
		buttons.clear()


func was_pressed(obj):
	for unit in selected_units:
		if unit.name == obj.name:
			unit.set_selected(false)
			break


func _ready():
	pass
