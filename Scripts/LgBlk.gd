extends RigidBody2D
var upg = preload("res://Scripts/UpgradeProgressions.gd").new()
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var health = 100
var type = "L"
var tx
var floored
func _ready():
	contact_monitor = true
	if get_parent().get_name() == "LBlkNde":
		type = "L"
		health = 150
	elif get_parent().get_name() == "MBlkNde":
		type = "M"
		health = 100
	elif get_parent().get_name() == "SBlkNde":
		type = "S"
		health = 30
	else:
		type = "X"
	tx = load("res://Assets/Blocks/"+type+"/"+str(GS.getPrestige())+".png")
	$Sprite.set_texture(tx)
func _process(delta):
	if position.x < 0:
		position.x = 300
		#get_parent().get_parent().breakBlock(type,position)
		#queue_free()
	elif position.x > 800:
		position.x = 700
		#get_parent().get_parent().breakBlock(type,position)
		#queue_free()
	else:
		pass
	if position.y < -400:
		position.y = -380
		#get_parent().get_parent().breakBlock(type,position)
		#queue_free()
	elif position.y > 740:
		position.y = 700
		#get_parent().get_parent().breakBlock(type,position)
		#queue_free()
	else:
		pass
		
func setFloored(val):
	floored = val
func save():
	print("savingBlock")
	GS.saveBlock(type,position,rotation)
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func die():
	#print("Killing block with type "+type)
	get_parent().get_parent().breakBlock(type,position)
	queue_free()




func _on_RigidBody2D_body_entered(body):
	var bodName = body.get_name()
	if bodName.begins_with("Wheel"):
		health -= 1
	elif bodName.begins_with("Tooth"):
		var toothpower = upg.getBuff("ToothForce",GS.getWheelForce())
		#print("TOOTH FORCE IS "+str(toothpower) )
		health -= toothpower
	if health <= 0:
		die()

func _on_TextureButton_pressed():
	var touchpowerr = upg.getBuff("TapValue",GS.getTapAmount())
	health -= touchpowerr
	if health <= 0:
		die()
