extends Panel
var extStr = preload("res://Scripts/Strings.gd").new()
var upg = preload("res://Scripts/UpgradeProgressions.gd").new()
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var price
var type

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func setup(val,dict):
	var theStrings = extStr.getUpgrade(val)
	type = val
	$TopLbl.set_text(theStrings.FriendlyName)
	var tx = load("res://Assets/Upgrades/"+val+".png")
	get_node("Sprite").set_texture(tx)
	get_node("Sprite").scale = Vector2(0.25,0.25)
	$CurrentLvl.set_text("Current Level : "+str(dict.lvl))
	$CurrBuff.set_text("Current "+str(theStrings.FriendlyName)+" "+str(dict.currBuff)+" "+str(theStrings.Abbr))
	$NextLvBuff.set_text("Next "+str(theStrings.FriendlyName)+" "+str(dict.nextBuff)+" "+str(theStrings.Abbr))
	price = int(dict.price)
	$Button.set_text("$"+str(price))
	if price > GS.getCash() or upg.getMax(type)<dict.nextBuff:
		$Button.set_disabled(true)
	else:
		$Button.set_disabled(false)
	if upg.getMax(type)<dict.nextBuff:
		$CurrentLvl.set_text("Current Level : "+str(dict.lvl)+" (max)")
		$CurrBuff.set_text("Current "+str(theStrings.FriendlyName)+" MAX "+str(dict.currBuff))
		$NextLvBuff.set_text("")
	
func updateShit():
	var lvl = GS.getupgradeLvl(type)
	var theStrings = extStr.getUpgrade(type)
	$CurrentLvl.set_text("Current Level : "+str(lvl))
	$CurrBuff.set_text("Current "+str(theStrings.FriendlyName)+" "+str(upg.getBuff(type,lvl))+" "+str(theStrings.Abbr))
	$NextLvBuff.set_text("Next "+str(theStrings.FriendlyName)+" "+str(upg.getNextBuff(type,lvl))+" "+str(theStrings.Abbr))
	price = int(upg.getPrice(type,lvl))
	$Button.set_text("$"+str(price))
	if price > GS.getCash() or upg.getMax(type)<upg.getNextBuff(type,lvl):
		$Button.set_disabled(true)
	else:
		$Button.set_disabled(false)
	if upg.getMax(type)<upg.getNextBuff(type,lvl):
		$CurrentLvl.set_text("Current Level : "+str(lvl)+" (max)")
		$CurrBuff.set_text("Current "+str(theStrings.FriendlyName)+" MAX "+str(upg.getBuff(type,lvl)))
		$NextLvBuff.set_text("")
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass



func _on_Button_pressed():
	GS.remCash(price)
	GS.setupgradeLvl(type)

