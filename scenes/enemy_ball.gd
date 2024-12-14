extends RigidBody2D
@onready var rigid_body_2d: RigidBody2D = $"."
@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# RayCast for player detection
@onready var raycast: RayCast2D = $RayCast2D  # RayCast to detect player beneath the ball
@export var damage: int = 20
@export var drop_speed: float = 30  # How fast the ball drops

var is_dropping = false

func _ready():
	# Set the RayCast2D direction to point downward by adjusting the cast_to property
	# Initially disable gravity so the ball doesn't fall
	gravity_scale = 0  # Set gravity to zero to prevent falling initially
	# Ensure the ball is stationary at the start
	linear_velocity = Vector2.ZERO  # Prevent ball from dropping initially

func _process(_delta):
	# If the RayCast hits the player, start dropping the ball
	if raycast.is_colliding() and raycast.get_collider().is_in_group("player") and not is_dropping:
		is_dropping = true
		gravity_scale = 1  # Enable gravity to make the ball fall
		linear_velocity = Vector2(0, drop_speed) # Apply downward force/velocity
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("apply_damage"):
		body.apply_damage(damage)
	rigid_body_2d.set_collision_mask_value(3, false)
	animated_sprite.play("exploding")
	var free_timer = Timer.new()
	free_timer.one_shot = true
	free_timer.wait_time = 1.6   # Wait for the animation to finish
	add_child(free_timer)
	free_timer.timeout.connect(_on_free_timer_timeout)
	free_timer.start()

func _on_free_timer_timeout():
	# Free the enemy node
	queue_free()

	queue_free()  # Destroy the ball
