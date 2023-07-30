extends Area2D

@onready var player = get_tree().get_current_scene().get_node("Player")

func _on_body_entered(body):
	if body == player:
		Input.action_release("move_up")
		Input.action_release("move_left")
		Input.action_release("move_right")
		Input.action_release("move_down")
		player.direction = Vector2.ZERO
		match get_tree().get_current_scene().name:
			"FirstRoom":
				get_tree().change_scene_to_file("res://scenes/Second_Room.tscn")
			"SecondRoom":
				get_tree().change_scene_to_file("res://scenes/Third_Room.tscn")
			"ThirdRoom":
				get_tree().change_scene_to_file("res://scenes/Final_Room.tscn")
	pass 
