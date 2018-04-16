extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Area2D_body_entered(body):
	print(body.get_name())
	body.set_axis_velocity(Vector2(200,0))
	body.setFloored(true)
	print("COINS = "+str(get_parent().get_node("CoinsNode").get_child_count()))


func _on_Bank_body_entered(body):
	print("killed coin")
	GS.addCash(GS.getCoinValue())
	body.queue_free()
