extends StaticBody2D

onready var globals = get_node("/root/Globals")
onready var Bullet = preload("res://source/scenes/Parent_Bullet.tscn")

export (float) var rotation_speed = PI
export (float) var cooldown = 0.5
export (int) var detect_radius = 100

var target = null
var can_shoot = true

var possible_targets = []

func _ready():
	$Detect_Radius/CollisionShape2D.shape.radius = detect_radius


func shoot():
	if can_shoot:
		var m = Bullet.instance()
		get_parent().add_child(m)
		m.start($Turret/Muzzle.global_transform, target)
		can_shoot = false
		yield(get_tree().create_timer(cooldown), "timeout")
		can_shoot = true

func find_target():
	if possible_targets.size() > 0:
		var closest = possible_targets[0]
		for unit in possible_targets:
			if position.distance_to(unit.global_position) < position.distance_to(closest.global_position):
				closest = unit
		target = closest
	else:
		target = null
			
func _physics_process(delta):
	if !target:
		find_target()
	elif target:
		$Turret.look_at(target.global_position)
		shoot()

func _on_Detect_Radius_body_entered(body):
	if body.is_in_group("Units"):
		possible_targets.append(body)


func _on_Detect_Radius_body_exited(body):
	if body.is_in_group("Units"):
		possible_targets.erase(body)
		find_target()

func _draw():
	# Draws some debug vectors.
	if !globals.debugging:
		return
	draw_circle(Vector2.ZERO, $Detect_Radius/CollisionShape2D.shape.radius, Color(1, 1, 0, 0.2))
