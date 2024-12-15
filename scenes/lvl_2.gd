extends Node2D
@export var scene_path: String = "res://path_to_scene.tscn"

func _ready():
	Globals.current_scene_path = scene_path
