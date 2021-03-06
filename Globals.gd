extends Node
var save_file = "user://saveFile.xws"
var RPC = preload("res://Scripts/rpc.gd")
var upg = preload("res://Scripts/UpgradeProgressions.gd").new()

var currentSaveData = {} ## EMPTY DICT
var saveEncyptionKey = ""
var isPhone
var isNewGame = true
var f
var coinsPerSec = 0.0
var fb 
var resolvedIdleOnStart = false
## StartingSave

var starterSave = { "Prestige":0,
					"Cash":0,
					"TapValue":0,
					"WheelRpm":0,
					"CoinValue":0,
					"WheelForce":0,
					"TeethNum":0,
					"IdleTimeOut":0,
					"IdlePercentage":0,
					"LastSavedTime":0,
					"LastCoinsPerSec":0,
					"BlockStates":{
								"Lblks":{},
								"Mblks":{},
								"Sblks":{},
								"Cblks":{},
								},
					"ads":true,
					}

func _ready():
	print("GLOBALS LOADED")
	if !OS.get_unique_id():
		saveEncyptionKey = "NotADeviceWeCanGetAKeyFrom"
		print("can't get OS key")
		isPhone = false
	else:
		saveEncyptionKey = OS.get_unique_id()
		isPhone = true
		print("got OS Key")
		get_tree().set_auto_accept_quit(false)
	if OS.get_name() == "Android":
		print("Init FireBase")
		fb = Engine.get_singleton("FireBase")
		fb.initWithFile("res://godot-firebase-config.json", get_instance_id());
		#fb.authConfig("'Google':true,'Facebook':false")
	else:
		print("not Android, Firebase Disabled")
	LoadGame()

## LoadSave
func LoadGame():
	f = File.new()
	if f.file_exists(save_file):
		f.open_encrypted_with_pass(save_file, File.READ, saveEncyptionKey)
		if f.is_open():
			currentSaveData = f.get_var()
			print("Save Game opened")
			#print(str(currentSaveData))
			isNewGame = false
			f.close()
			return currentSaveData
		else:
			print("unable to read file")
			makeNewSave()
	else:
		print("Save Game does not exist")
		makeNewSave()
func CheckEmptyGame():
	if currentSaveData.size() != 0:
		return false
	else:
		return true
func saveActiveGame():
	f = File.new()
	f.open_encrypted_with_pass(save_file, File.WRITE, saveEncyptionKey)
	f.store_var(currentSaveData)
	#print("saved - "+str(currentSaveData))
	f.close()
func eraseSaveGame():
	var dir = Directory.new()
	dir.remove(save_file)
	currentSaveData.clear()
	currentSaveData = {}
	print("Save fileremoved")
	LoadGame()
func setAds(val):
	currentSaveData["ads"] = val
func getAds():
	return currentSaveData.ads
func saveBlock(type,pos,rot):
	#print("globalsSavingBlock"+type+" "+str(pos)+" "+str(rot))
	if pos.y >700:
		pos.y = 620
	if type == "L":
		#print(str(currentSaveData.BlockStates.Lblks))
		var size = currentSaveData.BlockStates.Lblks.size()
		currentSaveData.BlockStates.Lblks[str(size+1)] = {"pos":pos,"rot":rot}
		#print(str(currentSaveData.BlockStates.Lblks))
	elif type == "M":
		var size = currentSaveData.BlockStates.Mblks.size()
		currentSaveData.BlockStates.Mblks[size+1] = {"pos":pos,"rot":rot}
	elif type == "S":
		var size = currentSaveData.BlockStates.Sblks.size()
		currentSaveData.BlockStates.Sblks[size+1] = {"pos":pos,"rot":rot}
	elif type == "C":
		var size = currentSaveData.BlockStates.Cblks.size()
		currentSaveData.BlockStates.Cblks[size+1] = {"pos":pos,"rot":rot}
	saveActiveGame()
func returnBlocks(type,clear):
	if clear:
		currentSaveData.BlockStates[type+"blks"].clear()
	else:
		pass
	if type == "L":
			#print("L"+str(currentSaveData.BlockStates.Lblks))
			return currentSaveData.BlockStates.Lblks
	elif type == "M":
			#print("M")
			return currentSaveData.BlockStates.Mblks
	elif type == "S":
			#print("S")
			return currentSaveData.BlockStates.Sblks
	elif type == "C":
			#print("C")
			return currentSaveData.BlockStates.Cblks

func checkBlocks():
	var c = 0
	c += currentSaveData.BlockStates.Lblks.size()
	c += currentSaveData.BlockStates.Mblks.size()
	c += currentSaveData.BlockStates.Sblks.size()
	c += currentSaveData.BlockStates.Cblks.size()
	if c == 0:
		return false
		print("NO BLOCKS")
	else:
		return true
		print("Gonna Load Blocks")
func makeNewSave():
	currentSaveData = starterSave
	setSaveTime()
func setSaveTime():
	var theTime = getTime()
	currentSaveData["LastSavedTime"] = getTime()
	saveActiveGame()
	print("TimeSaved")
func getSaveTime():
	return currentSaveData.LastSavedTime
func getTime():
	var www = RPC.new()
	var response = www.get("/api/idleG/time.php")
	if !response:
		return OS.get_unix_time()
		print("Time check failed failed failed")
	else:
		print(" system time is "+str(OS.get_unix_time()))
		print(" Web Time was - "+response.getBody())
		var theTime = int(response.getBody())
		print(theTime)
		print("TIME")
		if theTime == 0:
			theTime = OS.get_unix_time()
		print(theTime)
		print("Returned")
		return theTime
func resolveIdle():
	var theTime = getTime()
	if theTime == 0:
		theTime = OS.get_unix_time()
	if theTime != 0:
		var diff = (theTime - getSaveTime())
		if diff > upg.getBuff("TimeOut",getMaxIdleTime()):
			diff = upg.getBuff("TimeOut",getMaxIdleTime())
		var coins = diff*upg.getBuff("CoinValues",getCoinValue())
		print(coins)
		var profit = (coins*getSavedCoinsPerSec())
		print(profit)
		profit *= 0.25
		print(profit)
		print(int(profit))
		var dateTime = OS.get_datetime_from_unix_time(diff)
		addCash(profit)
		if diff < 60:
			return "you idled for "+str(dateTime.second)+"s. You made "+str(int(profit))+"."
		elif diff < 3600:
			return "you idled for "+str(dateTime.minute)+"m "+str(dateTime.second)+"s. You made "+str(int(profit))+"."
		else:
			return "you idled for "+str(dateTime.hour)+"h "+str(dateTime.minute)+"m "+str(dateTime.second)+"s. You made "+str(int(profit))+"."
	else:
		return "Could not get the time"

func setCoinsPerSec(val):
	coinsPerSec = float(val)
	#print("CPS set to "+str(val))
func getCoinsPerSec():
	return float(coinsPerSec)
func saveCoinsPerSec():
	currentSaveData["LastCoinsPerSec"] = float(coinsPerSec)
	#print("CPS saved as "+str(coinsPerSec))
func getSavedCoinsPerSec():
	return currentSaveData.LastCoinsPerSec
func getPrestige():
	return currentSaveData.Prestige
func setPrestige():
	currentSaveData.Prestige += 1
	resetUpg()
func resetUpg():
	currentSaveData.Cash = 0
	currentSaveData.TapValue=0
	currentSaveData.WheelRpm=0
	currentSaveData.CoinValue=0
	currentSaveData.WheelForce=0
	currentSaveData.TeethNum=0
	currentSaveData.IdleTimeOut=0
	currentSaveData.IdlePercentage=0
	currentSaveData.LastSavedTime=0
	currentSaveData.LastCoinsPerSec=0
func setMaxIdleTime(secs):
	currentSaveData["IdleTimeOut"] = secs
func getMaxIdleTime():
	return currentSaveData.IdleTimeOut
func setIdlePercent(val):
	currentSaveData["IdlePercentage"] = val
func getIdlePercent():
	return currentSaveData.IdlePercentage
func addCash(val):
	currentSaveData["Cash"] += int(val)
func getCash():
	return currentSaveData.Cash
func remCash(val):
	currentSaveData["Cash"] -= int(val)
func setWheelRpm(val):
	currentSaveData["WheelRpm"] = val
func getWheelRpm():
	return currentSaveData.WheelRpm
func setTapAmount(val):
	currentSaveData["TapValue"] = val
func getTapAmount():
	return currentSaveData.TapValue
func setWheelForce(val):
	currentSaveData["WheelForce"] = val
func getWheelForce():
	return currentSaveData.WheelForce
func setCoinValue(val):
	currentSaveData["CoinValue"] = val
func getCoinValue():
	return currentSaveData.CoinValue
func setTeethNum(val):
	currentSaveData["TeethNum"] = val
func getTeethNum():
	return currentSaveData.TeethNum
func calcPrestigePrice():
	var lv = getPrestige()
	var init = (1000*1000)
	for i in lv:
		init *= 3.213423
	return int(init)
func getupgradeLvl(type):
	var response
	if type =="RPM":
		response = getWheelRpm()
	if type == "TapValue":
		response = getTapAmount()
	elif type == "ToothForce":
		response = getWheelForce()
	elif type == "ToothNumber":
		response = getTeethNum()
	elif type == "CoinValues":
		response = getCoinValue()
	elif type == "TimeOut":
		response = getMaxIdleTime()
	elif type == "IdlePercentage":
		response = getIdlePercent()
	return response
var prestigeNames = ["Wood","Stone","Iron","Steel","Diamond"]
func getPrestigeName(val):
	print("Got name !!! ")
	print(val)
	return prestigeNames[val]
func setupgradeLvl(type):
	var response
	if type =="RPM":
		response = getWheelRpm()
		setWheelRpm(response+1)
	if type =="TapValue":
		response = getTapAmount()
		setTapAmount(response+1)
	elif type == "ToothForce":
		response = getWheelForce()
		setWheelForce(response+1)
	elif type == "ToothNumber":
		response = getTeethNum()
		setTeethNum(response+1)
	elif type == "CoinValues":
		response = getCoinValue()
		setCoinValue(response+1)
	elif type == "TimeOut":
		response = getMaxIdleTime()
		setMaxIdleTime(response+1)
	elif type == "IdlePercentage":
		response = getIdlePercent()
		setIdlePercent(response+1)
	saveActiveGame()
	