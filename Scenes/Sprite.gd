extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var spr = load("res://Assets/Conveyor/"+str(GS.getPrestige())+".png")
	texture = spr
func _process(delta):
	rotate(0.4)
