extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	_on_Timer_timeout()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Timer_timeout():
	$CashLbl.set_text("$"+str(GS.getCash()))
	$CpSlbd.set_text(str(GS.getCoinsPerSec())+"/sec")
