extends Area2D

@onready var passUI = get_tree().get_current_scene().get_node("camera/PasswordUI")
@onready var player = get_tree().get_current_scene().get_node("Player")
@onready var textEdit = get_tree().get_current_scene().get_node("camera/PasswordUI/monitorsprite/TextEdit")

var permanentinvisibility := false

# Called when the node enters the scene tree for the first time.
func _ready():
	passUI.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(len(textEdit.text) >= 18):
		textEdit.text = textEdit.text.left(18)
	textEdit.set_caret_column(len(textEdit.text))
	if Input.is_action_just_pressed("enter"):
		var text = textEdit.text
		textEdit.text = ""
		if text.to_lower() == "nadia\n":
			player.emit_signal("level3_complete")
			passUI.visible = false
			permanentinvisibility = true
			pass
	pass


func _on_body_entered(body):
	if !permanentinvisibility && body == player:
		passUI.visible = true
		passUI.get_node("monitorsprite/TextEdit").call_deferred("grab_focus")
	pass 


func _on_body_exited(body):
	if body == player:
		passUI.visible = false
	pass 
