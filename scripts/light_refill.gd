extends Area2D

@onready var animation_player = $AnimationPlayer
@export var item_id : String
@onready var animated_sprite = $AnimatedSprite2D
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var timer: Timer = $Timer

func _ready():
	animated_sprite.play("default")

func _on_body_entered(_body):
	animation_player.play("pickUp")
	Globals.lightScale = 5
	timer.start()


func _on_timer_timeout() -> void:
	if (point_light_2d.energy >= 0):
		point_light_2d.energy -= 0.1
	timer.start()
