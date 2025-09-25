extends Node2D

@export var player: NodePath
@export var spawn_interval: float = 600.0
@export var spawn_ahead: float = 2000.0
@export var random_offset: float = 150.0
@export var turret_scene: PackedScene   # <-- Added this

var last_spawn_x: float = 0.0
var player_ref: Node2D
@onready var turret_container: Node2D = $TurretContainer

func _ready():
	player_ref = get_node(player)

func _process(_delta: float) -> void:
	if player_ref == null:
		return
	var player_x = player_ref.global_position.x
	
	# keep spawning turrets ahead of the player
	while last_spawn_x < player_x + spawn_ahead:
		_spawn_turret(last_spawn_x + spawn_interval)
		last_spawn_x += spawn_interval

func _spawn_turret(x_pos: float) -> void:
	if turret_scene == null:
		push_warning("Turret scene is not assigned in Inspector!")
		return
	
	var turret = turret_scene.instantiate()
	var y_offset = randf_range(-random_offset, random_offset)
	turret.global_position = Vector2(x_pos, player_ref.global_position.y + y_offset)
	turret_container.add_child(turret)
