extends Node2D

@onready var on: Sprite2D = $on
@onready var off: Sprite2D = $off
@export_enum("tutorial", "lvl_2", "boss") var lvl = 0
var in_area: bool = false
var light_on: bool = false
var in_free_area: bool = false


func _ready() -> void:
	off.visible = true
	on.visible = false
func _process(_delta: float) -> void:
	if in_area and Input.is_action_just_pressed("interaction"):
		off.visible = false
		on.visible = true
		light_on = true
	if light_on and in_free_area:
		Globals.canLightScale = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_area = true



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_area = false
		


func _on_free_light_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_free_area = true # Replace with function body.


func _on_free_light_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_free_area = false
		Globals.canLightScale = true
