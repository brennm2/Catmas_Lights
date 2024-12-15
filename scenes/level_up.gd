extends Area2D

const LVL_BOSS = preload("res://scenes/lvl_boss.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	print(Globals.lvl_2)
	print(body)
	if body.is_in_group("player"):
		if Globals.lvl_2 == 4:
			get_tree().change_scene_to_packed(LVL_BOSS)
