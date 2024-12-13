extends CharacterBody2D

var SPEED = 100
const JUMP_VELOCITY = -300.0
@onready var game_manager = %GameManager
@onready var animated_sprite = $AnimatedSprite2D
@onready var grab_area = $grab_area
@onready var timer = $Timer
@onready var stone_anim = $stone_anim
var player_position = null
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var near_block = false
var facing_right = true
var facing_left = false
var target = null
var blocks_in_range = []
var block_offset = Vector2()
@export var coyote_time = 0.1
var jump_available = true
@onready var coyote_timer = $coyote_timer

func _physics_process(delta):
	if Global.kill == true:
		stone_anim.show() # show sprite
		stone_anim.play("stone")
	else:
		stone_anim.hide() # show sprite
	
	if not is_on_floor():
		if jump_available:
			if coyote_timer.is_stopped():
				coyote_timer.start(coyote_time)
		velocity.y += gravity * delta # Add the gravity.
	else:
		jump_available = true
		coyote_timer.stop()
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and (jump_available or near_block == true or is_on_wall()):
		velocity.y = JUMP_VELOCITY
		$jump.play()
		jump_available = false
	# get direction
	var direction = Input.get_axis("move_left", "move_right")
	# chosing animation 
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle_v2")
		else:
			animated_sprite.play("run_v2")
	else:
		animated_sprite.play("jump_v2")
		
	# flip the sprite and hit boxes
	if direction != 0 && (near_block == false && !Input.is_action_just_pressed("grab")):
		update_direction(direction)
	# manual flip
	if direction == 0 && Input.is_action_just_pressed("flip"):
		self.scale.x = -1
		if facing_right == true:
			facing_right = false
			facing_left = true
		else:
			facing_right = true
			facing_left = false
			
	# move speed
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()  
	
	if near_block and Global.kill == false:
		stone_anim.show() # show sprite
		stone_anim.play("hands")
	elif Global.kill == true:
		stone_anim.show() # show sprite
		stone_anim.play("stone")
	else:
		stone_anim.hide()
	
	if near_block and Input.is_action_pressed("grab") and direction != 0:
		if not $sound.playing:
			$sound.play()
		move_block(delta, direction)
	else:
		if $sound.playing:
			$sound.stop()
	
	if near_block and Input.is_action_just_pressed("interact") and (Global.path > 0 or Global.destroy > 0):
		change_block()
	
	if direction != 0  and self.is_on_floor():
		$steps.pitch_scale = randf_range(0.09,0.16)
		if not $steps.playing:
			$steps.play()
	else:
		if $steps.playing:
			$steps.stop()
	
	if Input.is_action_just_pressed("reset"):
		if Global.colide:
			get_tree().quit()
		else:
			Global.reset()

		

func _ready() -> void:
	self.position = Global.spawn_point
	
func update_direction(new_direction_x):
	if new_direction_x > 0 and not facing_right:
		facing_right = true
		facing_left = false
		self.scale.x = -1
	elif new_direction_x < 0 and not facing_left:
		facing_right = false
		facing_left = true
		self.scale.x = -1

func _on_grab_area_body_entered(body):
	if body.is_in_group("Blocks"):
		if not blocks_in_range.has(body):
			blocks_in_range.append(body)
		target = blocks_in_range[0]
		SPEED = 51
		near_block = true
	
	if body.name == "vilan" and Global.kill == true:
		Engine.time_scale = 0.5
		Global.colide = true
		timer.start()

func _on_grab_area_body_exited(body):
	if body.is_in_group("Blocks"):
		blocks_in_range.erase(body) 
		if blocks_in_range.size() > 0:
			target = blocks_in_range[0]
		else:
			target = null
			near_block = false
			SPEED = 100

	
func move_block(delta, direction): # tenho de mover no mesmo processo para eles nao descincronizarem
	if target:
		var move_vector = Vector2(direction * SPEED * delta, 0)
		target.move_and_collide(move_vector)
		$sound.pitch_scale = randf_range(0.4,0.65)
	
func change_block():
	if target:
		if Global.path > 0:
			target.get_node("CollisionShape2D").queue_free()
		elif Global.destroy > 0:
			target.queue_free()

func _on_timer_timeout():
	Engine.time_scale = 1
	self.position = Vector2(3384, -2046)
	Global.spawn_point = Vector2(3384, -2046)
	
func coyote_timeout():
	jump_available = false
