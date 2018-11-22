extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var screen_size = OS.get_screen_size() 
var window_size = OS.get_window_size()
func _ready():
	OS.set_window_position(screen_size*0.5 - window_size*0.5) # Windows screen position fix
	print("MAINMENU:  MAIN MENU LOADED")
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_PlayBtn_pressed():
	get_tree().change_scene("res://Scenes/Node2D.tscn")


func _on_delete_pressed():
	GS.eraseSaveGame()
