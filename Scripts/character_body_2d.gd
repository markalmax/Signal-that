extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("Crouch"):
		scale.y /= 2
		$CollisionShape2D.shape.extents.y /= 2
		$CollisionShape2D.position.y += $CollisionShape2D.shape.extents.y

	if Input.is_action_just_released("Crouch"):
		scale.y *= 2
		$CollisionShape2D.shape.extents.y *= 2
		$CollisionShape2D.position.y -= $CollisionShape2D.shape.extents.y / 2
	
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
