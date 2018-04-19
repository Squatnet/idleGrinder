extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var RPC = preload("rpc.gd")
var lrgBlk = preload("res://Scenes/LgBlk.tscn")
var medBlk = preload("res://Scenes/MdBlk.tscn")
var SmlBlk = preload("res://Scenes/SmBlk.tscn")
var Coin = preload("res://Scenes/Coin.tscn")
var www


func _ready():
	if GS.CheckEmptyGame():
		GS.makeNewSave()
	www = RPC.new()
	$Wheel2.setSide("R")
	$Ui/PopupPanel/writeME.set_text(GS.resolveIdle())
	$Ui/PopupPanel.popup_centered()
	if GS.checkBlocks():
		var L = GS.returnBlocks("L",true)
		var M = GS.returnBlocks("M",true)
		var S = GS.returnBlocks("S",true)
		var C = GS.returnBlocks("C",true)
		for i in L:
			respawnLgBlk(L[i])
		for i in M:
			respawnMdBlk(M[i])
		for i in S:
			respawnSmBlk(S[i])
		for i in C:
			respawnCoin(C[i])
	else:
		spawnLgBlk()
		spawnMedBlk(Vector2(rand_range(200,700),-200))
		spawnSmBlk(Vector2(rand_range(170,800),0))
		spawnSmBlk(Vector2(rand_range(170,800),-20))
func _process(delta):
	if $LBlkNde.get_child_count() < 1:
		spawnLgBlk()
func _on_Button_pressed():
	var newRpm = get_node("LineEdit").get_text()
	$Wheel.setRpm(float(newRpm))
	$Wheel2.setRpm(float(newRpm))
func spawnLgBlk():
	#print("currentLblk = "+str(get_node("LBlkNde").get_child_count()))
	if get_node("LBlkNde").get_child_count() < 5:
		var newBlk = lrgBlk.instance()
		randomize()
		newBlk.position =  Vector2(rand_range(150,800),-400)
		randomize()
		var scl = rand_range(0.5,1)
		newBlk.scale = Vector2(scl,scl)
		$LBlkNde.add_child(newBlk)
		#print("spawned LBlk with scale "+str(scl))
	else: 
		print("Too many lBlk")
func respawnLgBlk(pos,rot):
	#print("currentLblk = "+str(get_node("LBlkNde").get_child_count()))
	var newBlk = lrgBlk.instance()
	newBlk.position = pos
	newBlk.rotation = rot
	$LBlkNde.add_child(newBlk)
func spawnMedBlk(pos):
	var num = int(rand_range(3,5))
	for i in num:
		var newBlk = medBlk.instance()
		randomize()
		newBlk.position =  pos
		randomize()
		var scl = rand_range(0.5,1)
		newBlk.add_force(Vector2(scl*10,scl*10),Vector2(scl*10,scl*3))
		newBlk.scale = Vector2(scl,scl)
		$MBlkNde.add_child(newBlk)
		#print("spawned MBlk with scale "+str(scl))
func respawnMdBlk(pos,rot):
	#print("currentLblk = "+str(get_node("LBlkNde").get_child_count()))
	var newBlk = medBlk.instance()
	newBlk.position = pos
	newBlk.rotation = rot
	$MBlkNde.add_child(newBlk)
func spawnSmBlk(pos):
	var num = int(rand_range(3,5))
	for i in num:
		var newBlk = SmlBlk.instance()
		randomize()
		newBlk.position =  pos
		randomize()
		var scl = rand_range(0.5,1)
		newBlk.add_force(Vector2(scl*10,scl*10),Vector2(scl*10,scl*3))
		newBlk.scale = Vector2(scl,scl)
		$SBlkNde.add_child(newBlk)
		#print("spawned SBlk with scale "+str(scl))
func respawnSmBlk(pos,rot):
	#print("currentLblk = "+str(get_node("LBlkNde").get_child_count()))
	var newBlk = SmlBlk.instance()
	newBlk.position = pos
	newBlk.rotation = rot
	$SBlkNde.add_child(newBlk)
func spawnCoin(pos):
	var newCoin = Coin.instance()
	newCoin.position = pos
	$CoinsNode.add_child(newCoin)
	#print("Added Coin")
func respawnCoin(pos,rot):
	#print("currentLblk = "+str(get_node("LBlkNde").get_child_count()))
	var newBlk = Coin.instance()
	newBlk.position = pos
	newBlk.rotation = rot
	$CoinsNode.add_child(newBlk)
func breakBlock(type,pos):
	print(type)
	if type == "L":
		spawnMedBlk(pos)
	elif type == "M":
		spawnSmBlk(pos)
	elif type == "S":
		spawnCoin(pos)
	print(pos)

