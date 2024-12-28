extends Node2D


@export var damage_per_second: float = 0.5
@onready var timer: Timer = $Timer
var playerCanTakeDamage = true

var player_in_spike: Node2D = null

func _process(_delta: float) -> void:
	if player_in_spike and Globals.lightScale > 0.7 and playerCanTakeDamage == true:
		player_in_spike.apply_damage(damage_per_second * _delta)
		playerCanTakeDamage = false

func _on_death_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and Globals.lightScale > 0.7 and playerCanTakeDamage == true:
		body.apply_damage(damage_per_second)
		player_in_spike = body
		timer.start()
		playerCanTakeDamage = false

func _on_timer_timeout() -> void:
	if player_in_spike and Globals.lightScale > 0.7:
		player_in_spike.apply_damage(damage_per_second)
		playerCanTakeDamage = true 

func _on_death_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_spike = null
		timer.stop()
