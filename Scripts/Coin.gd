extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var floored = false
var timedOut = false
func _ready():
	var tx = load("res://Assets/Coins/"+str(int(GS.getCoinValue()/4))+".png")
	$Sprite.set_texture(tx)
func save():
	GS.saveBlock("C",position,rotation)
func setFloored(val):
	floored = val
func _process(delta):
	if timedOut:
		position.x = 556
		linear_velocity += Vector2(0,40)
	if floored == true:
		gravity_scale = 0
		if linear_velocity <= Vector2(1000,0):
			linear_velocity += Vector2(40,0)


func _on_Timer_timeout():
	timedOut = true
