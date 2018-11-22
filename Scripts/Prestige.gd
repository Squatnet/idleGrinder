extends Panel
var currpr
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func setup():
	var rx = load("res://Assets/Upgrades/Prestige/"+str(GS.getPrestigeName(GS.getPrestige()))+".png")
	$Sprite.set_texture(rx)
	$TopLbl.set_text("Advance")
	$CurrBuff.set_text("Current : "+str(GS.getPrestigeName(GS.getPrestige())))
	print("PRESTIGGGE"+str(GS.getPrestige())+" PPPP "+str(GS.prestigeNames.size()-1))
	if GS.getPrestige() >= GS.prestigeNames.size()-1:
		$NextLvBuff.set_text("Next : MAX !")
	else:
		$NextLvBuff.set_text("Next : "+str(GS.getPrestigeName(GS.getPrestige()+1)))
	$Button.set_text("$"+str(GS.calcPrestigePrice()))
	if GS.calcPrestigePrice() > GS.getCash() or GS.getPrestige() == (GS.prestigeNames.size()-1):
		$Button.set_disabled(true)
	else:
		$Button.set_disabled(false)
func updateShit():
	setup()
func _on_Button_pressed():
	GS.remCash(str(currpr))
	GS.setPrestige()
	get_tree().reload_current_scene()
