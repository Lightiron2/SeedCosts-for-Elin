extends Node
class_name seedCostsC

func chkDic(f: float) -> bool:
	#check if seedcost and seedname dic matches version number.
	
	return false


const firstVersion: Dictionary = {}



const dicOfDics: Dictionary = {"1.0" = firstVersion,}

func getDic(f: float) -> Dictionary:
	var key: String = str(f)
	if dicOfDics.has(key):
		return dicOfDics[key]
	var errorDic: Dictionary = {"Error" = true}
	return errorDic
