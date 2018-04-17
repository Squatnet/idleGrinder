extends Node
var save_file = "user://saveFile.xws"
var RPC = preload("res://Scripts/rpc.gd")
var currentSaveData = {} ## EMPTY DICT
var saveEncyptionKey = ""
var isPhone
var isNewGame = true
var f
var coinsPerSec = 0

## StartingSave

var starterSave = {
					"Cash":0,
					"WheelRpm":2,
					"CoinValue":10,
					"WheelForce":1,
					"TeethNum":3,
					"IdleTimeOut":900,
					"LastSavedTime":0,
					"LastCoinsPerSec":0,
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
func saveActiveGame():
	f = File.new()
	f.open_encrypted_with_pass(save_file, File.WRITE, saveEncyptionKey)
	f.store_var(currentSaveData)
	#print("saved - "+str(currentSaveData))
	f.close()
#
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
	var profit = (coins*getSavedCoinsPerSec())
	var dateTime = OS.get_datetime_from_unix_time(diff)
	print(str(diff)+" - "+str(profit)+" - "+str(dateTime.hour)+"h, "+str(dateTime.minute)+"m, "+str(dateTime.second))
	
		
func setCoinsPerSec(val):
	coinsPerSec = val
func getCoinsPerSec():
	return coinsPerSec
func saveCoinsPerSec():
	currentSaveData["LastCoinsPerSec"] = coinsPerSec
func getSavedCoinsPerSec():
	return currentSaveData.LastCoinsPerSec
func setMaxIdleTime(secs):
	currentSaveData["IdleTimeOut"] = secs
func getMaxIdleTime():
	return currentSaveData.IdleTimeOut
func addCash(val):
	currentSaveData["Cash"] += val
func getCash():
	return currentSaveData.Cash
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