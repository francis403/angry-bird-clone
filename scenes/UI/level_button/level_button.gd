extends TextureButton
class_name LevelButton

const HOVER_SCLAE: Vector2 = Vector2(1.1, 1.1)
const DEFAULT_SCALE: Vector2 = Vector2.ONE

@export var level_number: int = 1

@onready var level_title: Label = $MarginContainer/VBoxContainer/LevelTitle
@onready var level_score: Label = $MarginContainer/VBoxContainer/LevelScore

var level_scene: PackedScene

func _ready() -> void:
	level_scene = load("res://scenes/levels/levels/level_%s/level_%s.tscn" % [level_number, level_number])
	var best_level_score = ScoreManager.get_best_for_level(str(level_number))
	level_title.text = str(level_number)
	level_score.text = str(best_level_score)


func _on_pressed() -> void:
	ScoreManager.set_level_selected(level_number)
	get_tree().change_scene_to_packed(level_scene) # Replace with function body.


func _on_mouse_entered() -> void:
	self.scale = HOVER_SCLAE # Replace with function body.


func _on_mouse_exited() -> void:
	self.scale = DEFAULT_SCALE
