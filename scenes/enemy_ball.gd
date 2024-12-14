extends Area2D

@onready var raycast: RayCast2D = $RayCast2D  # RayCast to detect player beneath
@onready var collision_shape: CollisionShape2D = $CollisionShape2D  # Collision shape for overlapping player
@export var damage: int = 2
@export var drop_speed: float  # Drop speed in pixels per second

var is_dropping = false  # Tracks if the ball is currently dropping

func _ready():
	# Ensure the RayCast2D is enabled
	raycast.enabled = true
	
	# Connect the area_entered signal for collision
	self.connect("body_entered", self._on_body_entered)

func _process(delta):
	if raycast.is_colliding() and raycast.get_collider().is_in_group("player") and not is_dropping:
		# Start dropping when the player is detected beneath
		is_dropping = true

	if is_dropping:
		# Drop the ball by changing its position
		position.y += drop_speed * delta
		
	if is_dropping and position.y > 500:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		# Apply damage to the player
		if body.has_method("apply_damage"):
			body.apply_damage(damage)
		# Destroy the ball
		queue_free()
