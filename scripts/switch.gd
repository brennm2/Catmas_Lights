extends Node2D

@onready var on: Sprite2D = $on
@onready var off: Sprite2D = $off



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		on.visible = true
		off.visible = false
	else:
		on.visible = false
		off.visible = true
