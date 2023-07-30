extends Area2D

var inside := false

@onready var player = get_tree().get_current_scene().get_node("Player")
@onready var journal = get_tree().get_current_scene().get_node("camera").get_node("Journal")
@onready var prompt = get_tree().get_current_scene().get_node("locker/prompt")


var firstdigit:=-1
var seconddigit:=-1
var thirddigit := -1
var fourthdigit := -1
var permanentinvisibility := false

func _on_body_entered(body):
	if body == player:
		if permanentinvisibility == false:
			prompt.visible = true
		inside = true
		prompt.text = "This locker has a cipher"
	pass # Replace with function body.


func _on_body_exited(body):
	if body == player:
		prompt.visible = false
		inside = false
		firstdigit = -1
		seconddigit = -1
		thirddigit = -1
		fourthdigit = -1
		#prompt.get_node("ColorRect").visible = false
	pass # Replace with function body.



func _physics_process(_delta):
	if inside:
		for i in range(10):
			if Input.is_action_just_pressed("num"+str(i)):
				if firstdigit == -1:
					firstdigit = i
					#prompt.get_node("ColorRect").visible = true
					prompt.text = "First digit registered"
				elif seconddigit == -1:
					#prompt.get_node("ColorRect").visible = false
					seconddigit = i
					prompt.text = "Second digit registered"
				elif thirddigit == -1:
					thirddigit = i
					prompt.text = "Third digit registered"
				else:
					fourthdigit = i
					if check_code(firstdigit,seconddigit,thirddigit,fourthdigit) == true:
						prompt.visible = false
						permanentinvisibility = true
						player.emit_signal("level2_complete")
					else:
						prompt.text = "Try Again"
					firstdigit = -1
					seconddigit = -1
					thirddigit = -1
					fourthdigit = -1
		pass

@warning_ignore("shadowed_variable")
func check_code(firstdigit:int , seconddigit:int, thirddigit:int, fourthdigit:int) -> bool:
	return firstdigit == 2 && seconddigit == 7 && thirddigit == 0 && fourthdigit == 3
