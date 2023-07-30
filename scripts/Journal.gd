extends Control

signal toggle_journal

func _ready():
	self.visible = false
	get_parent().get_node("CanvasModulate").visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
@onready var camera = self.get_parent()
@onready var root = self.get_parent().get_parent()

@onready var lanterns = [root.get_node("PaddedRoomFloor").get_node("Bed").get_node("Lantern"), \
root.get_node("PaddedRoomFloor").get_node("SpotlightSprite01").get_node("Lantern"), \
root.get_node("PaddedRoomFloor").get_node("SpotlightSprite02").get_node("Lantern")]

@onready var lantern_energies = [root.get_node("PaddedRoomFloor").get_node("Bed").get_node("Lantern").energy, \
root.get_node("PaddedRoomFloor").get_node("SpotlightSprite01").get_node("Lantern").energy, \
root.get_node("PaddedRoomFloor").get_node("SpotlightSprite02").get_node("Lantern").energy ]

@onready var playerview = root.get_node("Player").get_node("playerview")
const playerview_energy = 0.1
@onready var player = root.get_node("Player")

var emit := false
var paused := false
var eligible := false
	

func _process(_delta):
	if eligible and Input.is_action_just_pressed("toggle_journal"):
		Input.action_release("move_up")
		Input.action_release("move_left")
		Input.action_release("move_right")
		Input.action_release("move_down")
		player.direction = Vector2.ZERO
		emit = true
		
	if emit and eligible:
		emit_signal("toggle_journal")
		emit = false
	
	if paused:
		move_lantern()
	
@export var speed := 1

func move_lantern():
	if Input.is_action_pressed("move_left"):
		$Light.position += Vector2.LEFT * speed
	if Input.is_action_pressed("move_right"):
		$Light.position += Vector2.RIGHT * speed	
	if Input.is_action_pressed("move_up"):
		$Light.position += Vector2.UP * speed
	if Input.is_action_pressed("move_down"):
		$Light.position += Vector2.DOWN * speed
		

func _on_toggle_journal():
	self.visible = !self.visible
	if self.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if get_tree().get_current_scene().get_name() == "FirstRoom":
			for lantern in lanterns:
				lantern.energy = 0
			playerview.energy = 0
			$Light.energy = 1
			get_tree().paused = true
			paused = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		if get_tree().get_current_scene().get_name() == "FirstRoom":
			var i:=0
			for lantern in lanterns:
				lantern.energy = lantern_energies[i]
				i+=1
			playerview.energy = playerview_energy
			$Light.energy = 0
			get_tree().paused = false
			paused = false
	pass 
