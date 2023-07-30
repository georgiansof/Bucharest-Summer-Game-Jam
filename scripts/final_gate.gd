extends Sprite2D

@onready var player = get_tree().get_current_scene().get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@onready var ending_1 = "res://scenes/ending_1.tscn"
@onready var ending_2 = "res://scenes/ending_2.tscn"

func _on_door_1_body_entered(body):
	if body == player:
		get_tree().change_scene_to_file(ending_1)
	pass 


func _on_door_2_body_entered(body):
	if body == player:
		get_tree().change_scene_to_file(ending_2)
	pass 
