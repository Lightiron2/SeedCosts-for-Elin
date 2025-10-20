extends Node
class_name seedCostsC

func chkDic(f: float) -> bool:
	#check if seedcost and seedname dic matches version number.
	
	return false


const firstVersion: Dictionary = {}



const seedDics: Dictionary = {"1.0" = firstVersion,}
const typeDics: Dictionary = {"1.0" = ["Fiber","Flowers","Fruit","Grass","Herb","Mushroom","Nuts","Ornamental",
	"Pasture","Straw","Trees","Vegetable",]}

func getDic(seedFloat: float,typeFloat: float) -> Array:
	var seedKey: String = str(seedFloat)
	var typeKey: String = str(typeFloat)
	var tempArray: Array = []
	if seedDics.has(seedKey) && typeDics.has(typeKey):
		tempArray.append(seedDics[seedKey])
		tempArray.append(typeDics[typeKey])
		return tempArray
	return tempArray
