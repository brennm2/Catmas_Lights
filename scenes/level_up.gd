extends Area2D

const LVL_BOSS = preload("res://scenes/lvl_boss.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if Globals.lvl_2 == 4:
			get_tree().change_scene_to_packed(LVL_BOSS)
