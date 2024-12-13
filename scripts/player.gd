extends CharacterBody2D
@onready var player_light: PointLight2D = $playerLight
@onready var timer: Timer = $playerLight/Timer

var SPEED = 100
const JUMP_VELOCITY = -300.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var coyote_time = 0.1
var jump_available = true
@onready var coyote_timer: Timer = $coyote_timer
var texture_number = 0


var LIGHT_1 = preload("res://assets/sprites/light1.png")
var LIGHT_2 = preload("res://assets/sprites/light2.png")
var LIGHT_3 = preload("res://assets/sprites/light3.png")
var LIGHT_4 = preload("res://assets/sprites/light4.png")

func _ready() -> void:
	change_light_texture()

func _physics_process(delta):
	if (player_light.texture_scale > 0.5):
		player_light.texture_scale -= 0.1 * delta
	

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

func change_light_texture():
	timer.start()
	

func _on_timer_timeout() -> void:
	print("entrou")
	if (texture_number == 0):
		player_light.texture = LIGHT_1
		texture_number += 1
	elif (texture_number == 1):
		player_light.texture = LIGHT_2
		texture_number += 1
	elif (texture_number == 2):
		player_light.texture = LIGHT_3
		texture_number +=1
	elif (texture_number == 3):
		player_light.texture = LIGHT_4
		texture_number = 0
	change_light_texture()
		
		
