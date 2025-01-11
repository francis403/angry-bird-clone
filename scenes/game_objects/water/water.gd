extends Area2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	self.body_entered.connect(on_body_entered)
	
	
func on_body_entered(body:Node2D):
	if body is Player:
		audio_stream_player.play()
		body.die()
