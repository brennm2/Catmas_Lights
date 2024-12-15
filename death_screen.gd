extends Control
@onready var canvas_layer: CanvasLayer = $CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_layer.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



#func _on_restart_button_pressed():
	#var current_scene = get_tree().get_current_scene()
	#print("Reloading scene: ", current_scene.filename)
	#get_tree().change_scene(current_scene.filename)

func _on_player_player_died() -> void:
	canvas_layer.show()

func _on_button_pressed() -> void:
	if Globals.current_scene_path:
		get_tree().change_scene_to_file(Globals.current_scene_path)
		Globals.lightScale = 5
	else:
		print("Error: Current scene path not set.")
