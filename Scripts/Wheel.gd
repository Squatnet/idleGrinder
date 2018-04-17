extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var rpm = 2
var side = "L"
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func setSide(v):
	side = v
func getRpm():
	return rpm
func setRpm(val):
	rpm = val
func _process(delta):
	setRpm(GS.getWheelRpm())
	var degPerSec = (rpm*6.0) # 
	var actRot = (degPerSec*delta)
	if side == "L":
		rotation_degrees += actRot
	else:
		rotation_degrees -= actRot
	#print(rotation_degrees)