extends Node
class_name seedCostsC

const seedDics: Dictionary = {"1.0" = ["Cotton", "Normal Flower", "Blue Flower", "Sunflower", "Tulip",
	"White Flower","Yellow Flower", "Apple", "Banana", "Berry", "Cactus", "Grape", "Orange", "Palulu", "Pear",
	"Rainbow", "Weed", "Cattail","Blue Herb","Green Herb", "Purple Herb","Red Herb", "Tobacc", "Mushroom", "Api",
	"Coffee", "Crim", "Rafflesia", "Fern", "Pasture", "Silver","Rice", "Wheat", "Birch", "Cedar", "Cherry",
	"Christmas", "Coral", "Feywood", "Fir", "Mushroom Tree","Mahogany", "Oak", "Pine","Rosewood","Bamboo",
	"Cabbage","Cabocchi","Carrot","Corn","Imo","Radish","Red Pepper","SeaweedDeep","Tomato"],
}
const typeDics: Dictionary = {"1.0" = ["Fiber","Flowers","Fruit","Grass","Herb","Mushroom","Nuts","Ornamental",
	"Pasture","Straw","Trees","Vegetable",]
}

func getDics(seedF: float,typeF: float) -> Array:
	var a = chkDics(seedF,typeF)
	if a[0] && a[1]:
		return [seedDics[str(seedF)],typeDics[str(typeF)]]
	return []

func getSeedN(seedF: float) -> Array:
	return seedDics[str(seedF)]
func getTypeN(typeF: float) -> Array:
	return typeDics[str(typeF)]

func chkSeedDic(seedF: float) -> bool:
	return seedDics.has(str(seedF))
func chkTypeDic(typeF: float) -> bool:
	return typeDics.has(str(typeF))

func chkDics(seedF: float, typeF: float) -> Array:
	var a: Array = []
	a.append(chkSeedDic(seedF))
	a.append(chkTypeDic(typeF))
	return a
