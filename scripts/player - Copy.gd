extends CharacterBody2D

@onready var animator = $animator

const SPEED:float = 250.0
var direction:Vector2 = Vector2.ZERO

enum states {STAND_LEFT,STAND_RIGHT,STAND_FACING,STAND_BACK, WALK_LEFT, WALK_RIGHT, WALK_TOWARDS, WALK_AWAY}

var current_state = states.STAND_FACING
var current_facing_direction = Vector2.DOWN
var pressed_keys = {"left": false, "right": false, "up": false, "down": false}

var previouspos

func _ready():
	animator.play("stand_facing")

func _physics_process(_delta):
	process_input()
	animate()


func animate():
	if Input.is_action_just_pressed("move_left"):
		current_state = states.WALK_LEFT
		animator.play("walk_left")
		pressed_keys["left"] = true
	if Input.is_action_just_pressed("move_right"):
		current_state = states.WALK_RIGHT
		animator.play("walk_right")
		pressed_keys["right"] = true
	if Input.is_action_just_pressed("move_up"):
		current_state = states.WALK_AWAY
		animator.play("walk_away")
		pressed_keys["up"] = true
	if Input.is_action_just_pressed("move_down"):
		current_state = states.WALK_TOWARDS
		animator.play("walk_towards")
		pressed_keys["down"] = true
	
	if pressed_keys["left"] == true && pressed_keys["right"] == true:
		if direction.y == 0:
			animator.play("stand_facing")
			current_state = states.STAND_FACING
		elif direction.y == -1:
			animator.play("walk_away")
			current_state = states.WALK_AWAY
		elif direction.y == 1:
			animator.play("walk_towards")
			current_state = states.WALK_TOWARDS
	
	
	if pressed_keys["down"] == true && pressed_keys["up"] == true:
		if direction.x == 0:
			animator.play("stand_facing")
			current_state = states.STAND_FACING
		elif direction.x == -1:
			animator.play("walk_left")
			current_state = states.WALK_LEFT
		elif direction.x == 1:
			animator.play("walk_right")
			current_state = states.WALK_RIGHT
	
	if Input.is_action_just_released("move_left"):
		pressed_keys["left"] = false
		if current_state == states.STAND_FACING:
			animator.play("walk_right")
			current_state = states.WALK_RIGHT
		check_walk()
	if Input.is_action_just_released("move_right"):
		pressed_keys["right"] = false
		if current_state == states.STAND_FACING:
			animator.play("walk_left")
			current_state = states.WALK_LEFT
		check_walk()
	if Input.is_action_just_released("move_up"):
		pressed_keys["up"] = false
		if current_state == states.STAND_FACING:
			animator.play("walk_towards")
			current_state = states.WALK_TOWARDS
		check_walk()
	if Input.is_action_just_released("move_down"):
		pressed_keys["down"] = false
		if current_state == states.STAND_FACING:
			animator.play("walk_away")
			current_state = states.WALK_AWAY
		check_walk()
	
	
func check_walk():
	var moving: bool = false
	for dir in pressed_keys.values():
		if dir == true:
			moving = true
	
	if not moving:
		match current_state:
			states.WALK_LEFT:
				current_state = states.STAND_LEFT
				animator.play("stand_left")
			states.WALK_RIGHT:
				current_state = states.STAND_RIGHT
				animator.play("stand_right")
			states.WALK_TOWARDS:
				current_state = states.STAND_FACING
				animator.play("stand_facing")
			states.WALK_AWAY:
				current_state = states.STAND_BACK
				animator.play("stand_back")
	
	

func process_input():
	if Input.is_action_just_pressed("move_left"):
		direction.x += -1.0
		current_facing_direction = Vector2.LEFT
	if Input.is_action_just_pressed("move_right"):
		direction.x += 1.0
		current_facing_direction = Vector2.RIGHT
	if Input.is_action_just_pressed("move_up"):
		direction.y += -1.0
		current_facing_direction = Vector2.UP
	if Input.is_action_just_pressed("move_down"):
		direction.y += 1.0
		current_facing_direction = Vector2.DOWN
	
	if Input.is_action_just_released("move_left"):
		direction.x += 1.0
	if Input.is_action_just_released("move_right"):
		direction.x += -1.0
	if Input.is_action_just_released("move_up"):
		direction.y += 1.0
	if Input.is_action_just_released("move_down"):
		direction.y += -1.0
	
	velocity = direction * SPEED
	previouspos = position
	move_and_slide()

# VECTOR BASED MOVEMENT

#var direction:Vector2 = Vector2.ZERO
#const MAX_SPEED:float = 1000.0
#
#func _physics_process(delta):
#	if Input.is_action_pressed("move_left"):
#		direction += Vector2.LEFT * delta
#	if Input.is_action_pressed("move_right"):
#		direction += Vector2.RIGHT * delta
#	if Input.is_action_pressed("move_up"):
#		direction += Vector2.UP * delta
#	if Input.is_action_pressed("move_down"):
#		direction += Vector2.DOWN * delta
#	if not(Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right") || Input.is_action_pressed("move_up") || Input.is_action_pressed("move_down")):
#		direction = Vector2.ZERO
#
#	direction.x = clamp(direction.x, -1.0, 1.0)
#	direction.y = clamp(direction.y, -1.0, 1.0)
#
#	velocity = direction * MAX_SPEED
#
#	move_and_slide()
#

# BOILERPLATE

#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#
#
#func _physics_process(delta):
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta
#
#	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#
#	move_and_slide()
