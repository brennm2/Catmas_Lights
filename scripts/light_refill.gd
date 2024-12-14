extends Area2D

@onready var animation_player = $AnimationPlayer
@export var item_id : String
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	animated_sprite.play("default")

func _on_body_entered(_body):
	animation_player.play("pickUp")
	Globals.lightScale = 5
