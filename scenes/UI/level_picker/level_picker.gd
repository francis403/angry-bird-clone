extends Control
class_name LevelPicker

@onready var level_title: Label = %LevelTitle
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var panel_container: PanelContainer = $PanelContainer

@export var level_title_string: String = ""
@export var destination_level: PackedScene


func _ready() -> void:
	if panel_container != null:
		panel_container.mouse_entered.connect(on_hover_signal)
		panel_container.gui_input.connect(on_gui_input_signal)

		#panel_container.add_theme_color_override("bg_color", Color.GREEN)
	if level_title_string != "":
		level_title.text = level_title_string


func set_level_completed():
	var styleBox: StyleBoxFlat = panel_container.get_theme_stylebox("panel")
	styleBox.set("bg_color", Color.GREEN)
	panel_container.add_theme_stylebox_override("panel", styleBox)


func on_hover_signal():
	animation_player.play("hover")


func on_gui_input_signal(event: InputEvent):
	if event is not InputEventMouseButton:
		return
	if event.button_index != MOUSE_BUTTON_LEFT and !event.pressed:
		return
	if destination_level != null:
		get_tree().change_scene_to_packed(destination_level)

func on_level_finished_successfully():
	print("test")
