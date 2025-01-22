extends RigidBody2D
class_name Player

@onready var catapult_audio_stream_player: AudioStreamPlayer = $CatapultAudioStreamPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var state_label: Label = $StateLabel
@onready var arrow: Sprite2D = $Arrow
@onready var hitting_wood_audio_stream_player: AudioStreamPlayer = $HittingWoodAudioStreamPlayer

enum PLAYER_STATE {REST, ACTIVE, DRAGGING}

var initial_position: Vector2
var final_position: Vector2
var _state: PLAYER_STATE
var last_collision_count

func _ready() -> void:
	self.sleeping_state_changed.connect(on_sleeping_state_changed)
	self.body_entered.connect(on_body_entered_signal)
	visible_on_screen_notifier_2d.screen_exited.connect(on_screen_exited_signal)
	_state = PLAYER_STATE.REST
	last_collision_count = 0
	arrow.visible = false
	self.set_process(false)


#func _process(delta: float) -> void:
	#if last_collision_count != get_contact_count()\
		#and !hitting_wood_audio_stream_player.playing:
		#last_collision_count = get_contact_count()
		#hitting_wood_audio_stream_player.play()	

func die():
	PlayerSignals.player_died.emit()
	self.queue_free()

func _set_rest(freeze_flag: bool = true):
	if freeze_flag:
		self.freeze = true
	self.set_process(false)
	set_label_status()

func _set_dragging():
	_state = PLAYER_STATE.DRAGGING
	set_label_status()
	audio_stream_player.play()
	arrow.visible = true

func _set_active():
	self.freeze = false
	#Callable(self.set_process).call_deferred(true)
	_state = PLAYER_STATE.ACTIVE
	set_label_status()
	audio_stream_player.stop()
	arrow.visible = false

func set_label_status():
	#print(PLAYER_STATE.keys()[_state])
	if state_label != null:
		state_label.text = PLAYER_STATE.keys()[_state]

# Signals

func on_body_entered_signal(body: Node2D):
	if !hitting_wood_audio_stream_player.playing:
		hitting_wood_audio_stream_player.play()

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
			catapult_audio_stream_player.play()
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
		#arrow.scale = Vector2(arrow_scale, 1)
		
#SIGNALS#
func on_sleeping_state_changed():
	if self.sleeping:
		#PlayerSignals.player_stopped.emit()
		var colliding_bodies = get_colliding_bodies()
		if colliding_bodies.size() > 0:
			if colliding_bodies[0] is Cup:
				colliding_bodies[0].die()
			elif  colliding_bodies[0] is Basket:
				colliding_bodies[0].get_parent().queue_free()
		self.set_process(false)
		_state = PLAYER_STATE.REST
		set_label_status()
		die()
