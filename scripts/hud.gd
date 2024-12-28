extends CanvasLayer

@onready var label: Label = %Label

func _process(_delta: float) -> void:
	if (Globals.current_scene_path == "res://scenes/lvl_tuturial.tscn"):
		label.text = str(Globals.tutorial) + " / 3"
	elif (Globals.current_scene_path == "res://scenes/lvl_2.tscn"):
		label.text = str(Globals.lvl_2) + " / 4"
	elif (Globals.current_scene_path == "res://scenes/lvl_boss.tscn"):
		label.text = str(Globals.boss) + " / 9"
