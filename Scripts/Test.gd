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
	www = RPC.new()
	$Wheel2.setSide("R")
	spawnLgBlk()
	spawnMedBlk(Vector2(rand_range(200,700),-200))
	spawnSmBlk(Vector2(rand_range(170,800),0))
	spawnSmBlk(Vector2(rand_range(170,800),-20))
	GS.resolveIdle()
func _process(delta):
	if $LBlkNde.get_child_count() < 1:
		spawnLgBlk()
func _on_Button_pressed():
	var newRpm = get_node("LineEdit").get_text()
	$Wheel.setRpm(float(newRpm))
	$Wheel2.setRpm(float(newRpm))
func spawnLgBlk():
	print("currentLblk = "+str(get_node("LBlkNde").get_child_count()))
	if get_node("LBlkNde").get_child_count() < 5:
		var newBlk = lrgBlk.instance()
		randomize()
		newBlk.position =  Vector2(rand_range(150,800),-400)
		randomize()
		var scl = rand_range(0.5,1)
		newBlk.scale = Vector2(scl,scl)
		$LBlkNde.add_child(newBlk)
		print("spawned LBlk with scale "+str(scl))
		spawnSmBlk(Vector2(rand_range(170,800),-20))
	else: 
		print("Too many lBlk")
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
		print("spawned MBlk with scale "+str(scl))
	
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
		print("spawned SBlk with scale "+str(scl))

func spawnCoin(pos):
	var newCoin = Coin.instance()
	newCoin.position = pos
	$CoinsNode.add_child(newCoin)
	print("Added Coin")
func breakBlock(type,pos):
	print(type)
	if type == "L":
		spawnMedBlk(pos)
	elif type == "M":
		spawnSmBlk(pos)
	elif type == "S":
		spawnCoin(pos)
	print(pos)

