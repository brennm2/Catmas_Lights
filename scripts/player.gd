extends CharacterBody2D

var SPEED = 100
const JUMP_VELOCITY = -300.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var coyote_time = 0.1
var jump_available = true
@onready var coyote_timer: Timer = $coyote_timer

func _physics_process(delta):

	if not is_on_floor():
		if jump_available:
			if coyote_timer.is_stopped():
				coyote_timer.start(coyote_time)
		velocity.y += gravity * delta # Add the gravity.
	else:
		jump_available = true
		coyote_timer.stop()
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and jump_available:
		velocity.y = JUMP_VELOCITY
		jump_available = false
		
	# get direction
	var direction = Input.get_axis("move_left", "move_right")
	
	# move speed
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()  
		
func coyote_timeout():
	jump_available = false
