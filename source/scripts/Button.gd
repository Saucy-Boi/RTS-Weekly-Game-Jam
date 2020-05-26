extends TextureButton

signal was_pressed

func _on_Button_pressed():
	emit_signal("was_pressed")
	

func connect_me(obj, unit_name):
	connect("was_pressed", obj, "was_pressed", [self])
	$Label.text = unit_name
