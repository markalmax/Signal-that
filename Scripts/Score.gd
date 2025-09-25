extends Node

@export var player_path: NodePath
@export var distance_label_path: NodePath = NodePath("Score")
@export var highscore_label_path: NodePath = NodePath("HighScore")
@export var save_file: String = "user://save.cfg"

var player: Node2D = null
var start_x: float = 0.0
var best_distance: float = 0.0 
var high_score: float = 0.0

func _ready() -> void:
	player = get_node_or_null(player_path)
	start_x = float(player.global_position.x)
	var cfg := ConfigFile.new()
	var err := cfg.load(save_file)
	if err == OK:
		high_score = float(cfg.get_value("scores", "high_score", 0.0))
	else:
		high_score = 0.0
	_update_labels()
func _process(_delta: float) -> void:
	if player == null:
		return
	var distance := player.global_position.x - start_x
	if distance < 0.0:
		distance = 0.0
	if distance > best_distance:
		best_distance = distance
		if best_distance > high_score:
			high_score = best_distance
			var cfg := ConfigFile.new()
			cfg.set_value("scores", "high_score", high_score)
			cfg.save(save_file)
	_update_labels()

func _update_labels() -> void:
	var dist_label := get_node_or_null(distance_label_path)
	var hs_label := get_node_or_null(highscore_label_path)

	if dist_label:
		dist_label.text = str(int(best_distance)) + " m"
	if hs_label:
		hs_label.text = "Best: " + str(int(high_score)) + " m"
