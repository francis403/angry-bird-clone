extends Node

const DEFAULT_SCORE: int = 1000
const SAVE_FILE_PATH = "user://game.save"

var level_selected: int = 1
var level_scores: Dictionary = {}

func _ready() -> void:
	load_from_disc()

func set_level_selected(level: int): 
	level_selected = level
	
func get_level_selected():
	return level_selected


func set_score_for_level(score: int, level: String):
	check_and_add_base(level)
	if level_scores[level] > score:
		print("Setting new highscore: ", score)
		level_scores[level] = score
		save_to_disc()

func get_best_for_level(level: String):
	print("get_best_for_level level: ", level)
	check_and_add_base(level)
	return level_scores[level]

func check_and_add_base(level: String):
	if !level_scores.has(level):
		level_scores[level] = 1000
		
		
func save_to_disc():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	var score_json_str = JSON.stringify(level_scores)
	file.store_string(score_json_str)

func load_from_disc():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file == null:
		save_to_disc()
	else:
		var data = file.get_as_text()
		level_scores = JSON.parse_string(data)
	
