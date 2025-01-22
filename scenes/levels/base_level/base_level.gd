extends Level

const PLAYER = preload("res://scenes/player/player.tscn")
const MAIN = preload("res://scenes/game/game.tscn")

@onready var score_component: ScoreComponent = $ScoreComponent
@onready var animal_start_marker: Marker2D = $AnimalStartMarker

var player_instance: Player

func _ready() -> void:
	instantiate_player()
	PlayerSignals.player_died.connect(on_player_died_signal)

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_packed(MAIN)

func instantiate_player():
	if PLAYER != null && animal_start_marker != null:
		player_instance = PLAYER.instantiate()
		Callable(add_child).call_deferred(player_instance)
		player_instance.global_position = animal_start_marker.global_position
		player_instance._set_rest()

func level_passed():
	print("level_passed")
	self.level_completed = true
	level_finished_sucessfully.emit()
	Callable(get_tree().change_scene_to_file).call_deferred("res://scenes/game/game.tscn")
	#get_tree().change_scene_to_file("res://scenes/game/game.tscn")


#SIGNALS#
func on_player_died_signal():
	instantiate_player()
	
