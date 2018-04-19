extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var health = 100
var type = "L"
func _ready():
	contact_monitor = true
	if get_parent().get_name() == "LBlkNde":
		type = "L"
		health = 100
	elif get_parent().get_name() == "MBlkNde":
		type = "M"
		health = 70
	elif get_parent().get_name() == "SBlkNde":
		type = "S"
		health = 50
	else:
		type = "X"

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func die():
	print("Killing block with type "+type)
	get_parent().get_parent().breakBlock(type,position)
	queue_free()




func _on_RigidBody2D_body_entered(body):
	var bodName = body.get_name()
	if bodName.begins_with("Wheel"):
		health -= 2
	elif bodName.begins_with("Tooth"):
		health -= 7
	if health <= 0:
		die()