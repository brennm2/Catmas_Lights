extends Area2D

# Timer before explosion
@export var explosion_time: float = 2.0

# Damage or explosion radius
@export var explosion_radius: float = 100.0
@export var explosion_damage: int = 50

# Group name for the player
@export var player_group: String = "player"

var is_exploding = false
var blink_timer: Timer  # Timer for the blinking effect
var is_blinking_red = false

func _ready():
	# Connect signals using Callable for Godot 4.0+
	$Timer.timeout.connect(_on_timer_timeout)
	body_entered.connect(_on_body_entered)

	# Add a separate timer for blinking effect
	blink_timer = Timer.new()
	blink_timer.one_shot = false
	blink_timer.wait_time = 0.2  # Blink interval (in seconds)
	add_child(blink_timer)
	blink_timer.timeout.connect(_on_blink_timer_timeout)

func _on_body_entered(body):
	# Check if the body is in the "Player" group
	if body.is_in_group(player_group):
		# Start the explosion sequence if not already exploding
		if not is_exploding:
			is_exploding = true
			$Timer.start(explosion_time)
			blink_timer.start()  # Start the blinking effect

func _on_blink_timer_timeout():
	# Toggle between normal and red modulate for blinking effect
	is_blinking_red = !is_blinking_red
	$Sprite2D.modulate = Color(1, 0, 0) if is_blinking_red else Color(1, 1, 1)

func _on_timer_timeout():
	# Stop blinking and explode
	blink_timer.stop()
	$Sprite2D.modulate = Color(1, 1, 1)  # Reset to default
	explode()
	queue_free()  # Remove the enemy

func explode():
	# Create a circle shape for the explosion range
	var explosion_shape = CircleShape2D.new()
	explosion_shape.radius = explosion_radius

	# Set up the shape query parameters
	var query_params = PhysicsShapeQueryParameters2D.new()
	query_params.shape = explosion_shape
	query_params.transform = Transform2D(0, global_position)  # Center the explosion at the enemy's position
	query_params.collide_with_areas = true  # Collide with areas (optional)
	query_params.collide_with_bodies = true  # Collide with physics bodies

	# Perform the query
	var space_state = get_world_2d().direct_space_state
	var results = space_state.intersect_shape(query_params)

	# Apply damage or effects to all detected objects
	for result in results:
		var body = result.collider
		if body and body.has_method("apply_damage"):
			body.apply_damage(explosion_damage)

	# Optional: Add visual and sound effects
	create_explosion_effect()

func create_explosion_effect():
	# Add explosion particle effect or animation
	print("Boom! Explosion!")
