extends CharacterBody2D
@onready var player_light: PointLight2D = $playerLight
@onready var timer: Timer = $playerLight/Timer

signal player_died
var SPEED = 100
const JUMP_VELOCITY = -300.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var coyote_time = 0.1
var jump_available = true
@onready var coyote_timer: Timer = $coyote_timer
var texture_number = 0
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var idle_sleep_timer: Timer = $AnimatedSprite2D/idle_sleep_timer
@onready var interaction_timer: Timer = $interaction_timer
@onready var player_collision_jumping: CollisionShape2D = $playerCollisionJumping
@onready var player_collision: CollisionShape2D = $playerCollision
@export var sfx_cat_purring : AudioStream
@export var sfx_cat_death : AudioStream
@export var sfx_footStep : AudioStream
@onready var foot_step: AudioStreamPlayer2D = $footStep
@onready var interact_sound: AudioStreamPlayer2D = $interactSound
@onready var current_animation = animation.get_animation()
@onready var jump_sound: AudioStreamPlayer2D = $jumpSound
@onready var hit_timer: Timer = $AnimatedSprite2D/hit_timer
@onready var cat_hit: AudioStreamPlayer2D = $catHit
@onready var music_of_terror: AudioStreamPlayer2D = $music_of_terror

var footstep_frames : Array = [1]
var is_dead = false
var change_idle = true
var playerStartSleeping = false
var playerSleeping = false
var playerJumping = false
var playerMoving = false
var playerCanInteract = true
var playerCanTakeHit = true

var LIGHT_1 = preload("res://assets/sprites/light1.png")
var LIGHT_2 = preload("res://assets/sprites/light2.png")
var LIGHT_3 = preload("res://assets/sprites/light3.png")
var LIGHT_4 = preload("res://assets/sprites/light4.png")

func _ready() -> void:
	timer.start()
	

func _physics_process(delta):
	
	player_light.texture_scale = Globals.lightScale
	if (player_light.texture_scale > .7 && Globals.canLightScale && is_dead == false):
		player_light.texture_scale -= 0.1 * delta
		Globals.lightScale = player_light.texture_scale
	elif (is_dead == false && player_light.texture_scale < 0.7):
		is_dead = true
		player_died.emit()
		Globals.lightScale = 1
		animation.play("cat_death")
	
	var volume = (4 - Globals.lightScale) / 1.5
	music_of_terror.volume_db = lerp(-15, 0, volume)
	
	if not is_on_floor():
		if jump_available:
			if coyote_timer.is_stopped():
				coyote_timer.start(coyote_time)
		velocity.y += gravity * delta # Add the gravity.
	else:
		jump_available = true
		if playerJumping == true:
			playerJumping = false
			player_collision_jumping.disabled = true
			player_collision.disabled = false
			if (!is_dead):
				animation.play("idle_cat_2")
		coyote_timer.stop()
	
	if (Input.is_action_pressed("interaction") and playerCanInteract and is_on_floor()):
		animation.stop()
		animation.play("cat_interact")
		interact_sound.play()
		idle_sleep_timer.start()
		interaction_timer.start()
		playerCanInteract = false
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and jump_available and !is_dead:
		velocity.y = JUMP_VELOCITY
		jump_available = false
		if (playerMoving == false):
			animation.play("cat_jumping_stoped")
		else:
			animation.play("cat_jumping_move")
		playerJumping = true
		player_collision_jumping.disabled = false
		player_collision.disabled = false
		jump_sound.play()
		jump_sound.pitch_scale = randf_range(1, 1.10)
		idle_sleep_timer.start()
		
	# get direction
	var direction = Input.get_axis("move_left", "move_right")
	
	if (direction != 0 and self.is_on_floor() and !is_dead and playerCanInteract):
		foot_step.pitch_scale = randf_range(0.6, 1.5)
		if (not foot_step.playing):
			foot_step.play()
	else:
		if (foot_step.playing):
			pass
	# move speed and animation
	if direction and !is_dead && playerCanInteract:
		playerMoving = true
		if (direction == -1):
			animation.flip_h = true
		else:
			animation.flip_h = false
		if (is_dead == false):
			if (not playerJumping && playerCanTakeHit):
				animation.play("run_cat")
			velocity.x = direction * SPEED
			change_idle = true
			playerStartSleeping = false
			playerSleeping = false
	else:
		if (is_dead == false && playerCanInteract):
			playerMoving = false
			var random_number = randi_range(1, 2)
			if (random_number == 1 && change_idle == true && playerJumping == false && playerCanTakeHit):
				idle_sleep_timer.start()
				animation.play("idle_cat")
				change_idle = false
			elif (random_number == 2 && change_idle == true && playerJumping == false && playerCanTakeHit):
				idle_sleep_timer.start()
				animation.play("idle_cat_2")
				change_idle = false
			elif(playerStartSleeping == true && playerSleeping == false && playerJumping == false && playerCanTakeHit):
				animation.play("idle_cat_sleep")
			elif(playerSleeping == true && playerCanTakeHit):
				animation.play("idle_cat_sleep_loop")
			velocity.x = move_toward(velocity.x, 0, SPEED)
		else:
			velocity.x = 0
	if (Input.is_action_just_pressed("reset")):
		Globals.lightScale = 5
		resetLights()
		Engine.time_scale = 1
		get_tree().change_scene_to_file(Globals.current_scene_path)
	move_and_slide()  
	
func _input(event : InputEvent):
	if(Input.is_action_just_pressed("move_down") && is_on_floor()):
		position.y += 1

func resetLights():
	Globals.tutorial = 0;
	Globals.lvl_2 = 0;
	Globals.boss = 0;

func _on_idle_sleep_timer_timeout() -> void:
	if (Globals.canLightScale == false): #MUDAR ISSO PARA ==
		playerStartSleeping = true 
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if (playerStartSleeping == true):
		playerSleeping = true
	if (playerJumping == true):
		animation.play("idle_cat")
	
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
		
		
func _on_interaction_timer_timeout() -> void:
	if playerCanInteract == false:
		playerCanInteract = true
		animation.play("idle_cat")
		playerSleeping = false
		playerStartSleeping = false
	
	
func play_sfx(sfx_to_load):
	load_sfx(sfx_to_load)
	if not %sfx_player.playing:
		%sfx_player.play()
	else:
		if %sfx_player.playing:
			pass
		

func load_sfx(sfx_to_load):
	if %sfx_player.stream != sfx_to_load:
		%sfx_player.stop()
		%sfx_player.stream = sfx_to_load
	else:
		%sfx_player.stream = sfx_to_load


func _on_animated_sprite_2d_animation_changed() -> void:
	if animation:
		current_animation = animation.get_animation()

	if (current_animation == "idle_cat_sleep_loop"):
		play_sfx(sfx_cat_purring)
	elif (current_animation == "cat_death"):
		play_sfx(sfx_cat_death)
	#elif (current_animation == "run_cat"):
		#play_sfx(sfx_footStep)
	else:
		%sfx_player.stop()
	
func apply_damage(damage: float):
	#animation.stop()
	hit_timer.start()
	Globals.lightScale -= damage
	playerCanTakeHit = false
	if (Globals.lightScale > 0.7):
		cat_hit.play()
		animation.play("cat_hit")
	else:
		Globals.lightScale = 0.7


func _on_hit_timer_timeout() -> void:
	playerCanTakeHit = true
