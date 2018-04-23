extends Node
var upgrades = {
				"RPM":{"FriendlyName":"Wheel RPM","Abbr":"RPM"},
				"ToothForce":{"FriendlyName":"Tooth Force","Abbr":"Force"},
				"ToothNumber":{"FriendlyName":"No of Teeth","Abbr":"Teeth"},
				"CoinValues":{"FriendlyName":"Coin Value","Abbr":"val"},
				"TimeOut":{"FriendlyName":"Max Idle Time","Abbr":"secs"},
				"IdlePercentage":{"FriendlyName":"Idle Income %","Abbr":"%"}
				}
func getUpgrade(val):
	return upgrades[val]
