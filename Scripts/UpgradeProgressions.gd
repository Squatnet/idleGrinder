extends Node
var upgrades = {
				"RPM":{"LowVal":2,"Increment":1,"MaxVal":40,"StartPrice":10,"Multiplier":1.23},
				"ToothForce":{"LowVal":10,"Increment":10,"MaxVal":200,"StartPrice":300,"Multiplier":1.63},
				"ToothNumber":{"LowVal":3,"Increment":1,"MaxVal":6,"StartPrice":100,"Multiplier":11.43},
				"CoinValues":{"LowVal":1,"Increment":1,"MaxVal":20,"StartPrice":10,"Multiplier":4.23},
				"TimeOut":{"LowVal":900,"Increment":900,"MaxVal":28800,"StartPrice":234500,"Multiplier":2.45},
				"IdlePercentage":{"LowVal":0.1,"Increment":0.1,"MaxVal":1,"StartPrice":24456000,"Multiplier":13.23}
				}
func getBuff(upg,lvl):
	var upgDict = upgrades[upg]
	var currBuff = upgDict.LowVal + (upgDict.Increment*lvl)
	return currBuff
func getNextBuff(upg,lvl):
	lvl +=1
	var upgDict = upgrades[upg]
	var nxtBuff = upgDict.LowVal + (upgDict.Increment*lvl)
	return nxtBuff
func getPrice(upg,lvl):
	lvl += 1
	var upgDict = upgrades[upg]
	var price = lvl * (upgDict.StartPrice*upgDict.Multiplier)
	return price
func getMax(upg):
	var upgDict = upgrades[upg]
	return upgDict.MaxVal
