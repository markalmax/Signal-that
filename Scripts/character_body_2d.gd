extends CharacterBody2D

@export var jump_power: float = -400.0
@export var speed: float = 400.0
@export var gravity: float = 1000.0
@export var grapple_strength: float = 800.0
@export var max_grapple_distance: float = 600.0

var is_grappling: bool = false
var grapple_point: Vector2

@onready var rope: Line2D = $Line2D
@onready var ray: RayCast2D = $RayCast2D

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Grab"):
		var dir = (get_global_mouse_position() - global_position).normalized()
		ray.target_position = dir * max_grapple_distance
		ray.force_raycast_update()
		if ray.is_colliding():
			is_grappling = true
			grapple_point = ray.get_collision_point()
		else:
			is_grappling = false
	if Input.is_action_just_released("Grab"):
		is_grappling = false

	if is_grappling:
		var dir = (grapple_point - global_position).normalized()
		velocity += dir * grapple_strength * delta
		velocity.y += gravity * 0.2 * delta
	else:
		velocity.y += gravity * delta
	if Input.is_action_pressed("Restart"):
		get_tree().reload_current_scene()

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_power
	var direction := Input.get_axis("West", "East")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	if is_grappling:
		rope.points = [to_local(global_position), to_local(grapple_point)]
		rope.visible = true
	else:
		rope.visible = false

	move_and_slide()
