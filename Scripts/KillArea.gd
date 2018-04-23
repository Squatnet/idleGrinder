extends Node2D
var upg = preload("res://Scripts/UpgradeProgressions.gd").new()
# var b = "textvar"
var count = 0
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Area2D_body_entered(body):
	#print(body.get_name())
	body.set_axis_velocity(Vector2(200,0))
	body.setFloored(true)
	#print("COINS = "+str(get_parent().get_node("CoinsNode").get_child_count()))


func _on_Bank_body_entered(body):
	#print("killed coin")
	GS.addCash(upg.getBuff("CoinValues",GS.getCoinValue()))
	body.queue_free()
	count += float(upg.getBuff("CoinValues",GS.getCoinValue()))


func _on_Timer_timeout():
	count /= 10.0
	GS.setCoinsPerSec(float(count))
	GS.saveCoinsPerSec()
	#print("the count is"+str(count))
	count = 0
