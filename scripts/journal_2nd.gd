extends Control

signal toggle_journal

func _ready():
	self.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
@onready var camera = self.get_parent()
@onready var root = self.get_parent().get_parent()
@onready var player = root.get_node("Player")

var emit := false
var paused := false
	

func _process(_delta):
	if Input.is_action_just_pressed("toggle_journal"):
		Input.action_release("move_up")
		Input.action_release("move_left")
		Input.action_release("move_right")
		Input.action_release("move_down")
		player.direction = Vector2.ZERO
		emit = true
		
	if emit:
		emit_signal("toggle_journal")
		emit = false
		

func _on_toggle_journal():
	self.visible = !self.visible
	if self.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		paused = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		get_tree().paused = false
		paused = false
	pass 
