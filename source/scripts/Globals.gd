extends Node

#onready var multi_thread = get_node("/root/MultiThread")
#onready var Screen = get_node("/root/Screen")

#onready var DEBUG_SCREEN = preload("res://source/menus/DebugMenu.tscn")
var debugging = false


func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	
	if Input.is_action_just_pressed("debug"):
		debugging = !debugging
		print(debugging)
