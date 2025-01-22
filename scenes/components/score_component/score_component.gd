extends Node
class_name ScoreComponent

const MAIN = preload("res://scenes/game/game.tscn")

var points_needed: int
var current_attempts: int
var current_level: String
var current_points: int

func _ready() -> void:
	current_attempts = 0
	current_points = 0
	points_needed = get_tree().get_nodes_in_group(Constants.CUP_GROUP_NODE_GROUP).size()
	current_level = get_current_level()
	PlayerSignals.player_died.connect(on_player_died_signal)
	PlayerSignals.player_scored.connect(on_player_scored_signal)

func get_current_level() -> String:
	var result: String
	#var scene_path: String = get_tree().edited_scene_root.filename
	var scene_path: String = get_tree().current_scene.scene_file_path
	
	result = scene_path.get_slice("level_", 1)
	if result.contains("/"):
		result = result.get_slice("/", 0)
	print("result: ", result)
	return result

func on_player_died_signal():
	current_attempts += 1
	

func on_player_scored_signal():
	current_points += 1
	current_attempts += 1
	if current_points >= points_needed:
		print("level passed: ", current_level)
		print("highscore: ", current_attempts)
		ScoreManager.set_score_for_level(current_attempts, current_level)
		Callable(get_tree().change_scene_to_packed).call_deferred(MAIN)
