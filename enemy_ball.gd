extends Area2D

@onready var raycast: RayCast2D = $RayCast2D  # RayCast to detect player beneath
@onready var collision_shape: CollisionShape2D = $CollisionShape2D  # Collision shape for overlapping player
@export var damage: float = 2
@export var drop_speed: float  # Drop speed in pixels per second
@onready var enemy_ball_hit_sound: AudioStreamPlayer2D = $enemyBallHitSound
@onready var timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_dropping = false  # Tracks if the ball is currently dropping
var can_drop = true
var can_damage = true

func _ready():
	# Ensure the RayCast2D is enabled
	raycast.enabled = true
	
	# Connect the area_entered signal for collision
	self.connect("body_entered", self._on_body_entered)

func _process(delta):
	if raycast.is_colliding() and raycast.get_collider().is_in_group("player") and not is_dropping and can_drop:
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
			var tempPosition = position.y
			can_drop = false
			if (can_damage == true):
				body.apply_damage(damage)
				can_damage = false
				enemy_ball_hit_sound.play()
				animated_sprite_2d.play("exploding")
				is_dropping = false
				position.y = tempPosition
		# Destroy the ball
		timer.start()


func _on_timer_timeout() -> void:
	queue_free()
