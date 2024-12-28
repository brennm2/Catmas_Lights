extends Control
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var button = $CanvasLayer/MarginContainer/Panel/Button

var canEmit = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canEmit = false
	canvas_layer.hide()
	
func _process(delta):
	if (Input.is_action_just_pressed("jump") && canEmit == true):
		button.emit_signal("pressed")
		canEmit = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if Globals.boss == 9:
			Engine.time_scale = 0.05
			canvas_layer.show()
			canEmit = true


func resetLights():
	Globals.tutorial = 0;
	Globals.lvl_2 = 0;
	Globals.boss = 0;

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/lvl_tuturial.tscn")
	Globals.lightScale = 5
	resetLights()
	Engine.time_scale = 1
