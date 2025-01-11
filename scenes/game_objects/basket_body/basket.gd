extends Area2D
class_name Basket

@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

var player_is_inside: bool


func _ready() -> void:
	player_is_inside = false
	self.body_entered.connect(on_body_entered_signal)
	self.body_exited.connect(on_body_exited_signal)
	PlayerSignals.player_stopped.connect(on_player_stopped_signal)
	
func on_body_entered_signal(body: Node2D):
	print(on_body_entered_signal)
	if body is Player:
		player_is_inside = true
		
func on_body_exited_signal(body: Node2D):
	print(on_body_exited_signal)
	if body is Player:
		player_is_inside = false

func on_player_stopped_signal():
	print(on_player_stopped_signal)
	if player_is_inside:
		player_scored()
		
		
func player_scored():
	audio_stream_player.play()
	PlayerSignals.player_scored.emit()
	self.queue_free()
		
		
