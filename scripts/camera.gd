extends Camera2D

signal player_moved

@onready var player = self.get_parent().get_node("Player")
@onready var boundaryObj = self.get_parent().get_node("Lower-Right-Boundary")

var screenWidth = ProjectSettings.get_setting("display/window/size/viewport_width")
var screenHeight = ProjectSettings.get_setting("display/window/size/viewport_height")


func _on_player_moved():
	if player.position.x >= screenWidth / 2 && player.position.x <= boundaryObj.position.x - screenWidth / 2:
		position.x += player.deltapos.x
	if player.position.y >= screenHeight / 2 && player.position.y <= boundaryObj.position.y - screenHeight / 2:
		position.y += player.deltapos.y
	print(player.position)
	pass 
