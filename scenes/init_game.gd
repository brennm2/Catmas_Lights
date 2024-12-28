extends Control

const tutorial_lvl = preload("res://scenes/lvl_tuturial.tscn")
@onready var button = $CanvasLayer/Control/VBoxContainer3/VBoxContainer/Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("jump")):
		button.emit_signal("pressed")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(tutorial_lvl)
