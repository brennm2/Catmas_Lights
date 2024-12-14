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
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var idle_sleep_timer: Timer = $AnimatedSprite2D/idle_sleep_timer

var is_dead = false
var change_idle = true
var playerStartSleeping = false
var playerSleeping = false
var playerJumping = false
var playerMoving = false

var LIGHT_1 = preload("res://assets/sprites/light1.png")
var LIGHT_2 = preload("res://assets/sprites/light2.png")
var LIGHT_3 = preload("res://assets/sprites/light3.png")
var LIGHT_4 = preload("res://assets/sprites/light4.png")

func _ready() -> void:
	timer.start()

func _physics_process(delta):
	if (player_light.texture_scale > 0.7):
		player_light.texture_scale -= 0.1 * delta
	elif (is_dead == false):
		is_dead = true
		animation.play("cat_death")

	if not is_on_floor():
		if jump_available:
			if coyote_timer.is_stopped():
				coyote_timer.start(coyote_time)
		velocity.y += gravity * delta # Add the gravity.
	else:
		jump_available = true
		playerJumping = false
		coyote_timer.stop()
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and jump_available:
		velocity.y = JUMP_VELOCITY
		jump_available = false
		if (playerMoving == false):
			animation.play("cat_jumping_stoped")
		else:
			animation.play("cat_jumping_move")
		playerJumping = true
		idle_sleep_timer.start()
		
	# get direction
	var direction = Input.get_axis("move_left", "move_right")
	
	
	# move speed and animation
	if direction and !is_dead:
		playerMoving = true
		if (direction == -1):
			animation.flip_h = true
		else:
			animation.flip_h = false
		if (is_dead == false):
			if (not playerJumping):
				animation.play("run_cat")
			velocity.x = direction * SPEED
			change_idle = true
			playerStartSleeping = false
			playerSleeping = false
	else:
		if (is_dead == false):
			playerMoving = false
			var random_number = randi_range(1, 2)
			if (random_number == 1 && change_idle == true && playerJumping == false):
				idle_sleep_timer.start()
				animation.play("idle_cat")
				change_idle = false
			elif (random_number == 2 && change_idle == true && playerJumping == false):
				idle_sleep_timer.start()
				animation.play("idle_cat_2")
				change_idle = false
			elif(playerStartSleeping == true && playerSleeping == false && playerJumping == false):
				animation.play("idle_cat_sleep")
			elif(playerSleeping == true):
				animation.play("idle_cat_sleep_loop")
			
			velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()  

func _on_idle_sleep_timer_timeout() -> void:
	playerStartSleeping = true 
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if (playerStartSleeping == true):
		playerSleeping = true
	
func coyote_timeout():
	jump_available = false

func change_light_texture():
	timer.start()
	

func _on_timer_timeout() -> void:
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
		
		
