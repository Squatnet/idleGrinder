extends Node
var save_file = "user://saveFile.xws"
var currentSaveData = {} ## EMPTY DICT
var saveEncyptionKey
var isPhone
var f
## StartingSave

var starterSave = {"Cash":0,"WheelRpm":2,"CoinValue":1}

func _ready():
	print("GLOBALS LOADED")
	if !OS.get_unique_id():
		saveEncyptionKey = "NotADeviceWeCanGetAKeyFrom"
		print("can't get OS key")
		isPhone = false
	else:
		saveEncyptionKey = OS.get_unique_id()
		isPhone = true
		get_tree().set_auto_accept_quit(false)
	LoadGame()
		
## LoadSave
func LoadGame():
	f = File.new()
	if f.file_exists(save_file):
		f.open_encrypted_with_pass(save_file, File.READ, saveEncyptionKey)
		if f.is_open():
			currentSaveData = f.get_var()
			print("Save Game opened with "+str(currentSaveData.size())+" records")
			f.close()
			return currentSaveData
		else:
			print("unable to read file")
	else:
		print("Save Game does not exist")
		currentSaveData = starterSave
		return currentSaveData
func saveActiveGame():
	f = File.new()
	f.open_encrypted_with_pass(save_file, File.WRITE, saveEncyptionKey)
	f.store_var(currentSaveData)
	#print("saved - "+str(currentSaveData))
	f.close()


#

func addCash(val):
	currentSaveData.Cash += val
func getCash():
	return currentSaveData.Cash
func setWheelRpm(val):
	currentSaveData.WheelRpm = val
func getWheelRpm():
	return currentSaveData.WheelRpm
func getCoinValue():
	return currentSaveData.CoinValue
func setCoinValue(val):
	currentSaveData.CoinValue = val