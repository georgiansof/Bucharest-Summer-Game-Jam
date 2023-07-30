extends Area2D

var inside := false

@onready var player = get_tree().get_current_scene().get_node("Player")
@onready var journal = get_tree().get_current_scene().get_node("camera").get_node("Journal")
@onready var prompt = self.get_node("../../../RightLanternPrompt")

var firstdigit:=-1
var seconddigit:=-1
var permanentinvisibility := false

func _on_body_entered(body):
	if body == player:
		if permanentinvisibility == false:
			prompt.visible = true
		inside = true
		prompt.text = "Press two digits"
	pass # Replace with function body.


func _on_body_exited(body):
	if body == player:
		prompt.visible = false
		inside = false
		firstdigit = -1
		seconddigit = -1
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
				else:
					#prompt.get_node("ColorRect").visible = false
					seconddigit = i
					if check_code(firstdigit,seconddigit) == true:
						journal.lantern_energies[2] = 0.57
						self.get_parent().get_node("Lantern").energy = 0.57
						prompt.visible = false
						permanentinvisibility = true
						player.spotlight2on = true
						player.emit_signal("level1_complete")
					else:
						prompt.text = "Try Again"
					firstdigit = -1
					seconddigit = -1
		pass

func check_code(firstdigit:int , seconddigit:int) -> bool:
	return firstdigit == 7 && seconddigit == 6
