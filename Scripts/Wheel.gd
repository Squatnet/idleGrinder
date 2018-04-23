extends StaticBody2D
var upg = preload("res://Scripts/UpgradeProgressions.gd").new()
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var rpm = 2
var side = "L"
var teeth3 = preload("res://Scenes/Teeth/3.tscn")
var teeth4 = preload("res://Scenes/Teeth/4.tscn")
var teeth5 = preload("res://Scenes/Teeth/5.tscn")
var teeth6 = preload("res://Scenes/Teeth/6.tscn")


func _ready():
	setTeeth(upg.getBuff("ToothNumber",GS.getTeethNum()))
func setSide(v):
	side = v
func getRpm():
	return rpm
func setRpm(val):
	rpm = val
func _process(delta):
	setRpm(upg.getBuff("RPM",GS.getWheelRpm()))
	var degPerSec = (rpm*6.0) # 
	var actRot = (degPerSec*delta)
	if side == "L":
		rotation_degrees += actRot
	else:
		rotation_degrees -= actRot
	#print(rotation_degrees)
func setTeeth(num):
	var wtx = load("res://Assets/Wheels/"+str(GS.getPrestige())+".png")
	$Sprite.set_texture(wtx)
	for i in $Tettt.get_children():
		i.queue_free()
	var newSc
	if num == 3:
		newSc = teeth3.instance()
	elif num == 4:
		newSc = teeth4.instance()
	elif num == 5:
		newSc = teeth5.instance()
	else:
		newSc = teeth6.instance()
	$Tettt.add_child(newSc)
	var ttx = load("res://Assets/Teeth/"+str(GS.getPrestige())+".png")
	for i in get_tree().get_nodes_in_group("Sp"):
		i.set_texture(ttx)

func _on_Timer_timeout():
	setTeeth(upg.getBuff("ToothNumber",GS.getTeethNum()))
