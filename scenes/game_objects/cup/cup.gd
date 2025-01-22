extends StaticBody2D
class_name Cup

@onready var player_inside_cup_area_2d: Area2D = %PlayerInsideCupArea2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_player_inside_area: bool

func die():
	PlayerSignals.player_scored.emit()
	animation_player.play("vanish")

func on_player_area_entered_signal(node: Node2D):
	is_player_inside_area = true
	
func on_player_area_exited_signal(node: Node2D):
	is_player_inside_area = false
	
func on_player_stopped_signal():
	print(on_player_stopped_signal)
	print(is_player_inside_area)
	if is_player_inside_area:
		self.queue_free()
		
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	if anim_name == "vanish":
		self.queue_free()
