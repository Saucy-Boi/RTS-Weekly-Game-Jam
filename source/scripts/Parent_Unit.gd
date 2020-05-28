extends KinematicBody2D

onready var globals = get_node("/root/Globals")


export (int) var hp = 100
export (int) var max_hp = 100
export (int) var speed = 100  # Movement speed.

var av = Vector2.ZERO  # Avoidance vector.
var avoid_weight = 0.1  # How strongly to avoid other units.
var target_radius = 50  # Stop when this close to target.
var target = null setget set_target  
var selected = false setget set_selected
var velocity = Vector2.ZERO

func _ready():
	# shader material unique to each unit
	$Sprite.material = $Sprite.material.duplicate()
	# move hp bar to top of unit
	$HP_Bar.rect_position.x = -$HP_Bar.rect_size.x / 2
	$HP_Bar.rect_position.y = -$HP_Bar.rect_size.x * 0.75
	$HP_Bar.value = hp
	
func _physics_process(delta):
	velocity = Vector2.ZERO
	if target:
		# If there's a target, move toward it.
		velocity = position.direction_to(target)
		if position.distance_to(target) < target_radius:
			target = null
	# Find avoidance vector and add to velocity.
	av = avoid()
	velocity = (velocity + av * avoid_weight).normalized()
	#if velocity.length() > 0:
		# Rotate body to point in movement direction.
		#rotation = velocity.angle()
	var collision = move_and_collide(velocity * speed * delta)
	update()

func set_selected(value):
	# Draw a highlight around the unit if it's selected.
	selected = value
	if selected:
		$Sprite.material.set_shader_param("aura_width", 1)
	else:
		$Sprite.material.set_shader_param("aura_width", 0)
		
func set_target(value):
	target = value

func avoid():
	# Calculates avoidance vector based on nearby units.
	var result = Vector2.ZERO
	var neighbors = $Detect.get_overlapping_bodies()
	if !neighbors:
		return result
	for n in neighbors:
		result += n.position.direction_to(position)
	result /= neighbors.size()
	return result.normalized()


func change_hp(value):
	hp += value
	hp = clamp(hp, 0, max_hp)
	$HP_Bar.value = hp
	if hp == 0:
		queue_free()


func _draw():
	# Draws some debug vectors.
	if !globals.debugging:
		return
	draw_circle(Vector2.ZERO, $Detect/CollisionShape2D.shape.radius,
				Color(1, 1, 0, 0.2))
	draw_line(Vector2.ZERO, av.rotated(-rotation)*50, Color(1, 0, 0), 5)
	draw_line(Vector2.ZERO, velocity.rotated(-rotation)*speed, Color(0, 1, 0), 5)
	if target:
		draw_line(Vector2.ZERO, position.direction_to(target).rotated(-rotation)*50,
			Color(0, 0, 1), 5)
