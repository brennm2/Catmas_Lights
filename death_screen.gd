extends Control
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_layer.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_player_died() -> void:
	timer.start()

func _on_button_pressed() -> void:
	if Globals.current_scene_path:
		get_tree().change_scene_to_file(Globals.current_scene_path)
		Globals.lightScale = 5
	else:
		print("Error: Current scene path not set.")


func _on_timer_timeout() -> void:
	canvas_layer.show()
