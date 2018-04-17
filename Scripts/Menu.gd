extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	$SaveTime.set_text(str(GS.getSaveTime()))
	$CurrTime.set_text(str(GS.getTime()))
	$TimeDiff.set_text(str(GS.getTime()-GS.getSaveTime()))

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_PlayBtn_pressed():
	
	get_tree().change_scene("res://Scenes/Node2D.tscn")
