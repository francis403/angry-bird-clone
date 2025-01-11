extends RigidBody2D
class_name Player

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var state_label: Label = $StateLabel
@onready var arrow: Sprite2D = $Arrow

enum PLAYER_STATE {REST, ACTIVE, DRAGGING}

var initial_position: Vector2
var final_position: Vector2
var has_been_lauched: bool
var _state: PLAYER_STATE

var main_menu = preload("res://scenes/UI/level_picker/level_picker.tscn")


func _ready() -> void:
	visible_on_screen_notifier_2d.screen_exited.connect(on_screen_exited_signal)
	_state = PLAYER_STATE.REST
	has_been_lauched = false
	arrow.visible = false
	self.set_process(false)

func _process(delta: float) -> void:
	if _state == PLAYER_STATE.ACTIVE:
		var vel_sum = abs(linear_velocity.x) + abs(linear_velocity.y)
		if vel_sum > Constants.IS_STOPPED_SPEED_VALUE:
			has_been_lauched = true
		elif vel_sum < Constants.IS_STOPPED_SPEED_VALUE && has_been_lauched:
			PlayerSignals.player_stopped.emit()
			self.set_process(false)
			_state = PLAYER_STATE.REST
			set_label_status()


func die():
	PlayerSignals.player_died.emit()
	self.queue_free()

func _set_rest(freeze_flag: bool = true):
	if freeze_flag:
		self.freeze = true
	#self.set_process(false)
	set_label_status()

func _set_dragging():
	_state = PLAYER_STATE.DRAGGING
	set_label_status()
	audio_stream_player.play()
	arrow.visible = true

func _set_active():
	self.freeze = false
	Callable(self.set_process).call_deferred(true)
	_state = PLAYER_STATE.ACTIVE
	set_label_status()
	audio_stream_player.stop()
	arrow.visible = false

func set_label_status():
	#print(PLAYER_STATE.keys()[_state])
	if state_label != null:
		state_label.text = PLAYER_STATE.keys()[_state]

# Signals
func on_screen_exited_signal():
	print("self cleaning queue free")
	die()


func _input(event: InputEvent) -> void:
	# PLayer is in dragging state
	if _state == PLAYER_STATE.DRAGGING:
		final_position = get_global_mouse_position()
		# PLayer stopped is dragging
		if event.button_mask == 0:
			_set_active()
			apply_drag_push()
		else:
			update_arrow_sprite()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.button_mask == 1:
		initial_position = get_global_mouse_position()
		_set_dragging()
		
func apply_drag_push():
	var distance_between_points: float = initial_position.distance_to(final_position)
	var distance_between_x = initial_position.x - final_position.x
	var distance_between_y = initial_position.y - final_position.y
	#print("distance_between_points: ", distance_between_points)
	#print("distance_between_x: ", distance_between_x)
	#print("distance_between_y: ", distance_between_y)
	apply_central_force(
		Vector2(
			distance_between_x,
			distance_between_y
		).normalized() * distance_between_points * Constants.DRAG_FORCE
	)


func update_arrow_sprite():
	var distance_between_points: float = initial_position.distance_to(final_position)
	#var arrow_angle: float = initial_position.angle_to(final_position)
	var arrow_angle: float = initial_position.angle_to_point(final_position) + deg_to_rad(180)
	var arrow_scale = max(1, distance_between_points/100)
	#print("initial_pos: ", initial_position)
	#print("final_pos: ", final_position)
	#print("angle: ", angle)
	if arrow != null:
		arrow.rotation = arrow_angle
		arrow.scale = Vector2(arrow_scale, 1)
