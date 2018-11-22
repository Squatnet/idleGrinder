extends Control
var upg = preload("res://Scripts/UpgradeProgressions.gd").new()
var pan = preload("res://Scenes/UI/Upgrades/Upgrade.tscn")
var cnt = preload("res://Scenes/Control.tscn").instance()
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	_on_Timer_timeout()
	setupUpgrades()
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func setupUpgrades():
	var currX = 4
	for key in upg.upgrades:
		var dict = {}
		var lvl = GS.getupgradeLvl(key)
		dict["lvl"] = lvl
		dict["currBuff"] = upg.getBuff(key,lvl)
		dict["nextBuff"] = upg.getNextBuff(key,lvl)
		dict["price"] = upg.getPrice(key,lvl)
		var p = pan.instance()
		p.setup(key,dict)
		$ScrollContainer/HBoxContainer.add_child(p)
		$ScrollContainer/HBoxContainer.add_spacer(false)
	var pres = load("res://Scenes/UI/Upgrades/Prestige.tscn").instance()
	pres.setup()
	$ScrollContainer/HBoxContainer.add_child(pres)
	cnt.rect_size = Vector2(200,10)
	$ScrollContainer/HBoxContainer.add_child(cnt)
func cashLbls():
	$CashLbl.set_text("$"+str(GS.getCash()))
	$CpSlbd.set_text(str(GS.getCoinsPerSec())+"/sec")
func _on_Timer_timeout():
	cashLbls()
	for i in $ScrollContainer/HBoxContainer.get_children():
		if i.get_child_count() != 0:
			i.updateShit()

func _on_Button_pressed():
	GS.addCash(1000000)
