extends Node2D

#TODO: Think of better ways to implement new levels

const PLAYER = preload("res://scenes/player/player.tscn")

@onready var animal_start_marker: Marker2D = $AnimalStartMarker

@export var points_needed: int = 1

var player_instance: Player
var line_instance: ColorRect
var current_points: int


func _ready() -> void:
	instantiate_player()
	PlayerSignals.player_died.connect(on_player_died_signal)
	PlayerSignals.player_scored.connect(on_player_scored_signal)
	current_points = 0
	#pass

#
#func _physics_process(delta: float) -> void:
	#if player_instance != null:
		#draw_line_from(
			#animal_start_marker.global_position,
			#player_instance.global_position
		#)

func instantiate_player():
	if PLAYER != null && animal_start_marker != null:
		player_instance = PLAYER.instantiate()
		Callable(add_child).call_deferred(player_instance)
		player_instance.global_position = animal_start_marker.global_position
		player_instance._set_rest()

func draw_line_from(initial_position: Vector2, final_position: Vector2):
	if line_instance == null:
		line_instance = ColorRect.new()
		line_instance.global_position = initial_position
		line_instance.color = Color.RED
		line_instance.size.x = 10
		add_child(line_instance)
	line_instance.size.y = final_position.y - initial_position.y


func level_passed():
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")

#SIGNALS#

func on_player_died_signal():
	if line_instance != null:
		line_instance.queue_free()
	instantiate_player()
	

func on_player_scored_signal():
	current_points += 1
	if current_points >= points_needed:
		level_passed()
