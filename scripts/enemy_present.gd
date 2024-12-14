extends Area2D

# Timer before explosion
@export var explosion_time: float = 2
@export var explosion_damage: float = 2.5

# Sound streams
@export var beep_sound: AudioStream
@export var explosion_sound: AudioStream

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_exploding = false
var blink_timer: Timer  # Timer for the blinking effect
var is_blinking_red = false

func _ready():
	# Initialize blinking timer
	blink_timer = Timer.new()
	blink_timer.one_shot = false
	blink_timer.wait_time = 0.3  # Blink interval
	add_child(blink_timer)
	blink_timer.timeout.connect(_on_blink_timer_timeout)

	# Play idle animation initially
	animated_sprite.play("idle")

	# Connect the body_entered signal to handle the player's detection
	body_entered.connect(_on_body_entered)

	# Explicitly connect the timeout signal of the timer
	$Timer.timeout.connect(_on_timer_timeout)

func _on_body_entered(body):
	# Detect if the player enters the Area2D
	print("Body entered: ", body.name)  # Debug: Check if the body is detected
	if body.is_in_group("player") and not is_exploding:
		is_exploding = true
		# Play beeping sound
		audio_stream_player_2d.stream = beep_sound
		audio_stream_player_2d.play(1.7)
		$Timer.start(explosion_time)  # Start timer
		print("Explosion timer started")  # Debug statement
		blink_timer.start()  # Start blinking effect

func _on_blink_timer_timeout():
	# Toggle the red modulate effect to simulate blinking
	is_blinking_red = !is_blinking_red
	animated_sprite.modulate = Color(1, 0, 0) if is_blinking_red else Color(1, 1, 1)

func _on_timer_timeout():
	# When the timer finishes, stop blinking, play explosion sound and handle the explosion
	print("Explosion timer timed out!")  # Debug statement
	blink_timer.stop()
	animated_sprite.modulate = Color(1, 1, 1)  # Reset the modulate color

	# Play explosion sound
	audio_stream_player_2d.stream = explosion_sound
	audio_stream_player_2d.play()

	# Play explosion animation
	animated_sprite.play("exploding")

	# Handle explosion damage
	explode()

	# Set up a timer to free the node after the animation
	var free_timer = Timer.new()
	free_timer.one_shot = true
	free_timer.wait_time = 1.6   # Match the animation duration
	add_child(free_timer)
	free_timer.timeout.connect(_on_free_timer_timeout)
	free_timer.start()

func _on_free_timer_timeout():
	# Destroy the present after the explosion animation
	queue_free()

func explode():
	# Check for colliders in the explosion range (this is handled by the Area2D)
	for body in get_overlapping_bodies():
		print("Exploding on: ", body.name)  # Debug: Check which bodies are hit
		# Ensure the body can take damage
		if body.has_method("apply_damage"):
			body.apply_damage(explosion_damage)
