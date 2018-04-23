extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var floored = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func save():
	GS.saveBlock("C",position,rotation)
func setFloored(val):
	floored = val
func _process(delta):
	if floored == true:
		gravity_scale = 0
		if linear_velocity <= Vector2(1000,0):
			linear_velocity += Vector2(40,0)
