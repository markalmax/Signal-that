extends StaticBody2D

@export var bullet_scene: PackedScene
@export var fire_rate: float = 1.5   # seconds between shots
@export var bullet_speed: float = 800.0

var player_ref: Node2D
var shoot_timer: float = 0.0

func _ready():
	# Adjust path if needed depending on your scene tree
	player_ref = get_tree().get_root().get_node("Node2D/player")
	shoot_timer = fire_rate

func _process(delta: float) -> void:
	if player_ref == null:
		return
	
	# Rotate turret body to face player
	look_at(player_ref.global_position)
	
	# Handle shooting
	shoot_timer -= delta
	if shoot_timer <= 0:
		_shoot()
		shoot_timer = fire_rate

func _shoot():
	if bullet_scene == null:
		push_warning("No bullet scene assigned to turret!")
		return
	
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	
	bullet.global_position = global_position
	
	var dir = (player_ref.global_position - global_position).normalized()
	bullet.direction = dir
	bullet.speed = bullet_speed
