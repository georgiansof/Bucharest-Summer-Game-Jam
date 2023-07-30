extends CharacterBody2D

signal level1_complete
signal level2_complete
signal level3_complete

var spotlight1on := false
var spotlight2on := false

@onready var animator = $animator
@export var SPEED:float = 250.0
@onready var level1gate = get_tree().get_current_scene().get_node("PaddedRoomFloor/PaddedRoomGate01")
@onready var level2gate = get_tree().get_current_scene().get_node("LockerRoomFloorV2/LockerRoomGate01")
@onready var level3gate = get_tree().get_current_scene().get_node("MysteriousOfficeRoomFloor/MysteriousOfficeRoomGate09")

var direction:Vector2 = Vector2.ZERO

#const states = ["stand_left","stand_right","stand_facing","stand_back", "walk_left", "walk_right", "walk_towards", "walk_away"]

var current_state = "stand_facing"
var current_facing_direction = Vector2.DOWN
var pressed_keys = {"left": false, "right": false, "up": false, "down": false}

var previouspos
var deltapos = Vector2.ZERO
const move_threshold = 0.1

func _ready():
	current_state = "stand_facing"
	animator.play("stand_facing")
	if(get_tree().get_current_scene().name == "FirstRoom"):
		level1gate.get_node("Area2D/CollisionShape2D").position = Vector2(0.355, 200)
	if(get_tree().get_current_scene().name == "SecondRoom"):
		level2gate.get_node("Area2D/CollisionShape2D").position = Vector2(0, -200)
	if(get_tree().get_current_scene().name == "ThirdRoom"):
		level3gate.get_node("Area2D/CollisionShape2D").position = Vector2(0, 200)

func _physics_process(_delta):
	process_input()
	animate()


func animate():
	var next_anim = current_state
	if abs((previouspos-position).x) <= move_threshold && abs((previouspos-position).y) <= move_threshold:
		match current_state:
			"walk_right":
				next_anim = "stand_right"
			"walk_left":
				next_anim = "stand_left"
			"walk_away":
				next_anim = "stand_back"
			"walk_towards":
				next_anim = "stand_facing"
			"stand_right":
				if direction.y == 1:
					next_anim = "stand_facing"
				if direction.y == -1:
					next_anim = "stand_back"
			"stand_left":
				if direction.y == 1:
					next_anim = "stand_facing"
				if direction.y == -1:
					next_anim = "stand_back"
			"stand_facing":
				if direction.y == 0:
					if direction.x == 1:
						next_anim = "stand_right"
					if direction.x == -1:
						next_anim = "stand_left"
			"stand_back":
				if direction.y == 0:
					if direction.x == 1:
						next_anim = "stand_right"
					if direction.x == -1:
						next_anim = "stand_left"
	else:
		if direction.x == 1 && abs((previouspos-position).x) > move_threshold:
			next_anim = "walk_right"
		elif direction.x == -1 && abs((previouspos-position).x) > move_threshold:
			next_anim = "walk_left"
		else: #direction.x = 0
			if direction.y == -1:
				next_anim = "walk_away"
			elif direction.y == 1:
				next_anim = "walk_towards"
			else: #direction.x == 0 && direction.y == 0
				match current_state:
					"walk_left":
						next_anim = "stand_left"
					"walk_right":
						next_anim = "stand_right"
					"walk_away":
						next_anim = "stand_back"
					"walk_towards":
						next_anim = "stand_facing"
		
	if next_anim != current_state:
		current_state = next_anim
		animator.play(current_state)

func process_input():
	if Input.is_action_just_pressed("move_left"):
		direction.x += -1.0
	if Input.is_action_just_pressed("move_right"):
		direction.x += 1.0
	if Input.is_action_just_pressed("move_up"):
		direction.y += -1.0
	if Input.is_action_just_pressed("move_down"):
		direction.y += 1.0
	
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
	deltapos = position - previouspos
	if abs((previouspos-position).x) > move_threshold || abs((previouspos-position).y) > move_threshold:
		$"../camera".emit_signal("player_moved")
		pass

@onready var lantern = $"../PaddedRoomFloor/Bed/Lantern"
@onready var journal = $"../camera/Journal"

func _on_lantern_physics_body_entered(body):
	if body == self:
		lantern.reparent(self)
		lantern.position = Vector2.ZERO
		lantern.z_index = -3
		journal.eligible = true
		
	pass # Replace with function body.

@onready var opengatesprite1 = load("res://sprites/PaddedRoomGate08.png")
@onready var opengatesprite2 = load("res://sprites/LockerRoomGate08.png")
@onready var opengatesprite3 = load("res://sprites/MysteriousOfficeRoomGate08.png")

func _on_level_1_complete():
	if spotlight1on == true && spotlight2on == true:
		level1gate.texture = opengatesprite1
		level1gate.get_node("Area2D/CollisionShape2D").position = Vector2(0.355, -1.221)
	pass # Replace with function body.


func _on_level_2_complete():
	level2gate.texture = opengatesprite2
	level2gate.get_node("Area2D/CollisionShape2D").position = Vector2(-0.141, 1.658)
	pass # Replace with function body.


func _on_level_3_complete():
	level3gate.texture = opengatesprite3
	level3gate.get_node("Area2D/CollisionShape2D").position = Vector2(0.627, -2.77)
	pass 
