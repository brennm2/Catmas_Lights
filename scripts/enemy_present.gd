extends Area2D

# Timer before explosion
@export var explosion_time: float = 2.0

# Damage or explosion radius
@export var explosion_radius: float = 100.0
@export var explosion_damage: int = 50

# Sound streams
@export var beep_sound: AudioStream
@export var explosion_sound: AudioStream

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_exploding = false
var blink_timer: Timer  # Timer for the blinking effect
var is_blinking_red = false

func _ready():
	$Timer.timeout.connect(_on_timer_timeout)
	body_entered.connect(_on_body_entered)

	# Initialize blinking timer
	blink_timer = Timer.new()
	blink_timer.one_shot = false
	blink_timer.wait_time = 0.3  # Blink interval
	add_child(blink_timer)
	blink_timer.timeout.connect(_on_blink_timer_timeout)
	animated_sprite.play("idle")

func _on_body_entered(body):
	if body.is_in_group("player"):  # Ensure it's the player
		if not is_exploding:
			is_exploding = true
				# Play the beeping sound when ready
			audio_stream_player_2d.stream = beep_sound
			audio_stream_player_2d.play(1.7)
			$Timer.start(explosion_time)
			blink_timer.start()  # Start blinking

func _on_blink_timer_timeout():
	# Toggle red modulate for blinking effect
	is_blinking_red = !is_blinking_red
	animated_sprite.modulate = Color(1, 0, 0) if is_blinking_red else Color(1, 1, 1)

func _on_timer_timeout():
	# Stop blinking, play explosion sound, and switch to exploding animation
	blink_timer.stop()
	animated_sprite.modulate = Color(1, 1, 1)  # Reset to default color

	# Switch to explosion sound
	audio_stream_player_2d.stream = explosion_sound
	audio_stream_player_2d.play()  # Play explosion sound

	# Play the exploding animation
	animated_sprite.play("exploding")

	# Start explosion logic (damage and effect)
	explode()

	# Start a timer to free the node after the explosion animation finishes
	var free_timer = Timer.new()
	free_timer.one_shot = true
	free_timer.wait_time = 1.6   # Wait for the animation to finish
	add_child(free_timer)
	free_timer.timeout.connect(_on_free_timer_timeout)
	free_timer.start()

func _on_free_timer_timeout():
	# Free the enemy node
	queue_free()

func explode():
	var explosion_shape = CircleShape2D.new()
	explosion_shape.radius = explosion_radius

	var query_params = PhysicsShapeQueryParameters2D.new()
	query_params.shape = explosion_shape
	query_params.transform = Transform2D(0, global_position)
	query_params.collide_with_areas = true
	query_params.collide_with_bodies = true

	var space_state = get_world_2d().direct_space_state
	var results = space_state.intersect_shape(query_params)

	for result in results:
		var body = result.collider
		if body and body.has_method("apply_damage"):
			body.apply_damage(explosion_damage)
