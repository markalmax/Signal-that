extends CharacterBody2D

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("Up"):
		rotation = deg_to_rad(0)
	if Input.is_action_just_pressed("Right"):
		rotation = deg_to_rad(90)
	if Input.is_action_just_pressed("Down"):
		rotation = deg_to_rad(180)
	if Input.is_action_just_pressed("Left"):
		rotation = deg_to_rad(270)


   
