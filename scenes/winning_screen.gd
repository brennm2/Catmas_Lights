extends Control
@onready var canvas_layer: CanvasLayer = $CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_layer.hide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("HELLO")
	if body.is_in_group("player"):
		if Globals.boss == 9:
			Engine.time_scale = 0.05
			canvas_layer.show()
