extends Control
class_name CounterLabel

enum SIGNAL_TYPES {ATTEMPTS, DEATH, POINTS}

@onready var pre_text: Label = $HBoxContainer/PreText
@onready var counter: Label = $HBoxContainer/Counter

@export var signal_to_connect: SIGNAL_TYPES
@export var pre_text_string: String

#TODO: need to figure out how to specify which signal this should react
var counter_number: int

func _ready() -> void:
	counter_number = 0
	if pre_text_string != null:
		pre_text.text = pre_text_string
	if counter != null:
		counter.text = str(counter_number)
	
	if signal_to_connect == SIGNAL_TYPES.ATTEMPTS or\
		signal_to_connect == SIGNAL_TYPES.DEATH:
		PlayerSignals.player_died.connect(on_signal)
	elif signal_to_connect == SIGNAL_TYPES.POINTS:
		PlayerSignals.player_scored.connect(on_signal)
	

func on_signal():
	counter_number += 1
	counter.text = str(counter_number)
