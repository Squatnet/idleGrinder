extends Node
var save_file = "user://saveFile.xws"
var RPC = preload("res://Scripts/rpc.gd")
var currentSaveData = {} ## EMPTY DICT
var saveEncyptionKey = ""
var isPhone
var isNewGame = true
var f
var coinsPerSec = 0.0

## StartingSave

var starterSave = {
					"Cash":0,
					"WheelRpm":2,
					"CoinValue":1,
					"WheelForce":1,
					"TeethNum":3,
					"IdleTimeOut":900,
					"IdlePercentage":0.1,
					"LastSavedTime":0,
					"LastCoinsPerSec":0,
					"BlockStates":{
								"Lblks":[],
								"Mblks":[],
								"Sblks":[],
								"Cblks":[],
								}
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
	LoadGame()
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		setSaveTime()
		saveCoinsPerSec()
		 # default behavior
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		setSaveTime()
		saveCoinsPerSec()
		get_tree().quit()
	if isPhone:
		if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			setSaveTime()
			saveCoinsPerSec()
## LoadSave
func LoadGame():
	f = File.new()
	if f.file_exists(save_file):
		f.open_encrypted_with_pass(save_file, File.READ, saveEncyptionKey)
		if f.is_open():
			currentSaveData = f.get_var()
			print("Save Game opened")
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
func saveBlock(type,pos,rot):
	if type is "L":
		currentSaveData.BlockStates.Lblks.push_back({"pos":pos,"rot":rot})
	elif type is "M":
		currentSaveData.BlockStates.Mblks.push_back({"pos":pos,"rot":rot})
	elif type is "S":
		currentSaveData.BlockStates.Sblks.push_back({"pos":pos,"rot":rot})
	elif type is "C":
		currentSaveData.BlockStates.Cblks.push_back({"pos":pos,"rot":rot})
func returnBlocks(type,clear):
	var tmp = currentSaveData.BlockStates[type+"blks"]
	if clear:
		currentSaveData.BlockStates[type+"blks"].clear()
	else:
		pass
	return tmp
func checkBlocks():
	var c = 0
	c += currentSaveData.BlockStates.Lblks.size()
	c += currentSaveData.BlockStates.Mblks.size()
	c += currentSaveData.BlockStates.Sblks.size()
	c += currentSaveData.BlockStates.Cblks.size()
	if c == 0:
		return false
	else:
		return true
func makeNewSave():
	currentSaveData = starterSave
	setSaveTime()
func setSaveTime():
	currentSaveData["LastSavedTime"] = getTime()
	saveActiveGame()
func getSaveTime():
	return currentSaveData.LastSavedTime
func getTime():
	var www = RPC.new()
	var response = www.get("/api/idleG/time.php")
	if !response:
		return 0
	else:
		return int(response.getBody())
func resolveIdle():
	var diff = (getTime() - getSaveTime())
	if diff > getMaxIdleTime():
		diff = getMaxIdleTime()
	var coins = diff*getCoinValue()
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

func setCoinsPerSec(val):
	coinsPerSec = float(val)
	print("CPS set to "+str(val))
func getCoinsPerSec():
	return float(coinsPerSec)
func saveCoinsPerSec():
	currentSaveData["LastCoinsPerSec"] = float(coinsPerSec)
	print("CPS saved as "+str(coinsPerSec))
func getSavedCoinsPerSec():
	return currentSaveData.LastCoinsPerSec
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
	currentSaveData["cash"] -= int(val)
func setWheelRpm(val):
	currentSaveData["WheelRpm"] = val
func getWheelRpm():
	return currentSaveData.WheelRpm
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