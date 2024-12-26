extends Control
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var timer: Timer = $Timer
@onready var button = $CanvasLayer/Panel/Control/VBoxContainer/Button

var canEmit = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_layer.hide()
	canEmit = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("jump") && canEmit == true):
		button.emit_signal("pressed")
		canEmit = false


func _on_player_player_died() -> void:
	timer.start()
	
func resetLights():
	Globals.tutorial = 0;
	Globals.lvl_2 = 0;
	Globals.boss = 0;

func _on_button_pressed() -> void:
	if Globals.current_scene_path:
		get_tree().change_scene_to_file(Globals.current_scene_path)
		Globals.lightScale = 5
		resetLights()
	else:
		print("Error: Current scene path not set.")


func _on_timer_timeout() -> void:
	canvas_layer.show()
	canEmit = true
