extends Area2D

const LVL_2 = preload("res://scenes/lvl_2.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if Globals.tutorial == 0:
			get_tree().change_scene_to_packed(LVL_2)
