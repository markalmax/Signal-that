extends CharacterBody2D

@export var jump_power: float = -400.0
@export var speed: float = 400.0
@export var gravity: float = 1000.0
@export var grapple_strength: float = 800.0
@export var max_grapple_distance: float = 600.0

var is_grappling_left: bool = false
var grapple_point_left: Vector2

var is_grappling_right: bool = false
var grapple_point_right: Vector2

@onready var sprite: Sprite2D = $Sprite2D
@onready var rope_left: Line2D = $Line2
@onready var rope_right: Line2D = $Line2D
@onready var ray_left: RayCast2D = $RayCast2D
@onready var ray_right: RayCast2D = $RayCast2

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Grab"):
		var dir = (get_global_mouse_position() - global_position).normalized()
		ray_left.target_position = dir * max_grapple_distance
		ray_left.force_raycast_update()
		if ray_left.is_colliding():
			is_grappling_left = true
			grapple_point_left = ray_left.get_collision_point()
	if Input.is_action_just_released("Grab"):
		is_grappling_left = false

	if Input.is_action_just_pressed("Attack"):
		var dir = (get_global_mouse_position() - global_position).normalized()
		ray_right.target_position = dir * max_grapple_distance
		ray_right.force_raycast_update()
		if ray_right.is_colliding():
			is_grappling_right = true
			grapple_point_right = ray_right.get_collision_point()
	if Input.is_action_just_released("Attack"):
		is_grappling_right = false

	if is_grappling_left:
		var dir_left = (grapple_point_left - global_position).normalized()
		velocity += dir_left * grapple_strength * delta
		velocity.y += gravity * 0.2 * delta
	if is_grappling_right:
		var dir_right = (grapple_point_right - global_position).normalized()
		velocity += dir_right * grapple_strength * delta
		velocity.y += gravity * 0.2 * delta

	if not is_grappling_left and not is_grappling_right:
		velocity.y += gravity * delta

	if Input.is_action_pressed("Restart"):
		get_tree().reload_current_scene()

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_power

	var direction := Input.get_axis("West", "East")
	if direction:
		velocity.x = direction * speed
		if direction < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if is_grappling_left:
		rope_left.points = [to_local(global_position), to_local(grapple_point_left)]
		rope_left.visible = true
	else:
		rope_left.visible = false

	if is_grappling_right:
		rope_right.points = [to_local(global_position), to_local(grapple_point_right)]
		rope_right.visible = true
	else:
		rope_right.visible = false

	move_and_slide()
