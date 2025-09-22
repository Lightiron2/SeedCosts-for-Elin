extends Control

const Fiber: Dictionary = {"Cotton" = 0.0}
const Flowers: Dictionary = {"Normal" = 1.0,"Blue" = 1.0,"White" = 1.0,"Yellow" = 1.0}
const Fruit: Dictionary = {"Apple" = 3.0,"Banana" = 2.0,"Berry" = 1.0,"Cactus" = 3.0,"Grape" = 5.0,
"Orange" = 3.0,"Palulu" = 2.0,"Pear" = 3.0,"Rainbow" = 8.0}
const Grass: Dictionary = {"Weed" = 1.0,"Cattail" = 1.0}
const Herb: Dictionary = {"Blue" = 2.0, "Green" = 2.0,"Purple" = 2.0,"Red" = 2.0,"Tobacc" = 6.0}
const Mushroom: Dictionary = {"Mushroom" = 2.0}
const Nuts: Dictionary = {"Api" = 2.0,"Coffee" = 4.0,"Crim" = 2.0}
const Ornamental: Dictionary = {"Rafflesia" = 0.0,"Fern" = 0.0}
const Pasture: Dictionary = {"Pasture" = 0.5,"Silver" = 0.5}
const Straw: Dictionary = {"Rice" = 3.0,"Wheat" = 3.0}
const Trees: Dictionary = {"Birch" = 0.5,"Cedar" = 0.5,"Cherry" = 0.5,"Christmas" = 0.5,"Coral" = 7.0,
"Feywood" = 10.0,"Fir" = 0.5,"Mushroom Tree" = 0.5,"Mahogany" = 0.5,"Oak" = 0.5,"Pine" = 0.5,"Rosewood" = 0.5,}
const Vegetable: Dictionary = {"Bamboo" = 1.0,"Cabbage" = 4.0,"Cabocchi" = 4.0,"Carrot" = 3.0,
"Corn" = 4.0,"Imo" = 3.0,"Radish" = 4.0,"SeaweedDeep" = 4.0,"Tomato" = 3.0,}


const seedCostArray: Array[Dictionary] = [Fiber,Flowers,Fruit,Grass,Herb,Mushroom,Nuts,Ornamental,
	Pasture,Straw,Trees,Vegetable,]

var FiberChosen: Dictionary = {"Cotton" = 0.0}
var FlowersChosen: Dictionary = {"Normal" = 0.0,"Blue" = 0.0,"White" = 0.0,"Yellow" = 0.0}
var FruitChosen: Dictionary = {"Apple" = 0.0,"Banana" = 0.0,"Berry" = 0.0,"Cactus" = 0.0,"Grape" = 0.0,
"Orange" = 0.0,"Palulu" = 0.0,"Pear" = 0.0,"Rainbow" = 0.0}
var GrassChosen: Dictionary = {"Weed" = 0.0,"Cattail" = 1.0}
var HerbChosen: Dictionary = {"Blue" = 0.0, "Green" = 0.0,"Purple" = 0.0,"Red" = 0.0,"Tobacc" = 0.0}
var MushroomChosen: Dictionary = {"Mushroom" = 0.0}
var NutsChosen: Dictionary = {"Api" = 0.0,"Coffee" = 0.0,"Crim" = 0.0}
var PastureChosen: Dictionary = {"Pasture" = 0.0,"Silver" = 0.0}
var StrawChosen: Dictionary = {"Rice" = 0.0,"Wheat" = 0.0}
var TreesChosen: Dictionary = {"Birch" = 0.0,"Cedar" = 0.0,"Cherry" = 0.0,"Christmas" = 0.0,"Coral" = 0.0,
"Feywood" = 0.0,"Fir" = 0.0,"Mushroom Tree" = 0.0,"Mahogany" = 0.0,"Oak" = 0.0,"Pine" = 0.0,"Rosewood" = 0.0,}
var VegetableChosen: Dictionary = {"Bamboo" = 0.0,"Cabbage" = 0.0,"Cabocchi" = 0.0,"Carrot" = 0.0,
"Corn" = 0.0,"Imo" = 0.0,"Radish" = 0.0,"SeaweedDeep" = 0.0,"Tomato" = 0.0,}
var OrnamentalChosen: Dictionary = {"Rafflesia" = 0.0,"Fern" = 0.0}

var mutableDicsArray: Array[Dictionary] = [FiberChosen,FlowersChosen,FruitChosen,GrassChosen,HerbChosen,
	MushroomChosen,NutsChosen,OrnamentalChosen,PastureChosen,StrawChosen,TreesChosen,VegetableChosen,]

var maxFertility: float = 120.0:
	set(newCost):
		maxFertility = newCost
		updateFertilityLabels()
var fertilityCost: float = 0.0:
	set(newCost):
		fertilityCost = newCost
		updateFertilityLabels()

var cFlowers: float = 0.0
var cFruits: float = 0.0
var cGrass: float = 0.0
var cHerbs: float = 0.0
var cMushrooms: float = 0.0
var cNuts: float = 0.0
var cPastures: float = 0.0
var cStraws: float = 0.0
var cTrees: float = 0.0
var cVegetables: float = 0.0
var curCostArray: Array[float] = [cFlowers,cFruits,cGrass,cHerbs,cMushrooms,cNuts,
	cPastures,cStraws,cTrees,cVegetables]

@export var fertilityDifferenceLabel: Label
@export var SeedNameCountList: ItemList
@export var SeedNumCountList: ItemList
var seedCountTypeArray: Array = []

@export var inputBox: SpinBox
var preventTriggerOnSeedOrTypeChange: bool = false

var resetSafetyOne: bool = false
var resetSafetyTwo: bool = false

@export var seedList: ItemList
@export var typeList: ItemList
var typeNumber: int = 0

var nameTarget: String = "No Target"

var curCostReset: Array = []
var mutableReset: Array = []

func _ready() -> void:
	SeedNumCountList.clear()
	curCostReset = curCostArray
	mutableReset = mutableDicsArray
	updateFertilityLabels()

func calcFertCost(id: int,Name:String,ammount:float):
	if ammount < 0:
		return
	mutableDicsArray[id][Name] = ammount
	var newFertilityCost: float = 0.0
	for key in seedCostArray[id]:
		newFertilityCost += seedCostArray[id][key] * mutableDicsArray[id][key]
	curCostArray[id] = newFertilityCost
	var newTotalCost: float = 0.0
	for cost in curCostArray:
		newTotalCost += cost
	addToCountList(Name,ammount,id)
	fertilityCost = newTotalCost

func updateFertilityLabels():
	var newFertDif: float = maxFertility - fertilityCost
	fertilityDifferenceLabel.text = str(newFertDif)
	if newFertDif < 0:
		fertilityDifferenceLabel.add_theme_color_override("font_color",Color(0.6, 0.0, 0.0))
		return
	if newFertDif > 0:
		fertilityDifferenceLabel.add_theme_color_override("font_color",Color(0.0, 0.8, 0.0))
		return
	if newFertDif == 0:
		fertilityDifferenceLabel.add_theme_color_override("font_color",Color(0.4, 0.4, 0.4))
		return

func _on_seed_selected(index: int) -> void:
	SeedNumCountList.deselect_all()
	nameTarget = seedList.get_item_text(index)
	if inputBox.value > 0:
		preventTriggerOnSeedOrTypeChange = true
		inputBox.value = 0

func _on_seed_type_selected(index: int) -> void:
	if inputBox.value > 0:
		preventTriggerOnSeedOrTypeChange = true
		inputBox.value = 0
	typeNumber = index
	nameTarget = "No Target"
	if typeList.item_count > 0:
		seedList.clear()
	var typeDic: Dictionary = seedCostArray[index]
	for key in typeDic:
		seedList.add_item(key,null,true)

func _on_spin_box_value_changed(value: float) -> void:
	if preventTriggerOnSeedOrTypeChange:
		preventTriggerOnSeedOrTypeChange = false
		return
	if nameTarget == "No Target":
		return
	calcFertCost(typeNumber,nameTarget,value)

func _on_reset_safety_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	if index == 0:
		resetSafetyOne = !resetSafetyOne
	if index == 1:
		resetSafetyTwo = !resetSafetyTwo

func _on_reset_button_up() -> void:
	if resetSafetyOne && resetSafetyTwo == true:
		curCostArray = curCostReset
		mutableDicsArray = mutableReset
		SeedNameCountList.clear()
		SeedNumCountList.clear()
		seedCountTypeArray.clear()
		SeedNumCountList.deselect_all()
		seedList.deselect_all()
		fertilityCost = 0

func addToCountList(seedName:String,seedCount: float, arrayId: int):
	var countListNum: int = SeedNameCountList.item_count - 1
	if seedCount < 0:
		return
	while countListNum > -1:
		var sCL: String = SeedNameCountList.get_item_text(countListNum)
		if seedName == sCL:
			if seedCount == 0.0:
				SeedNameCountList.remove_item(countListNum)
				SeedNumCountList.remove_item(countListNum)
				seedCountTypeArray.remove_at(countListNum)
				return
			SeedNameCountList.set_item_text(countListNum,seedName)
			SeedNumCountList.set_item_text(countListNum,str(seedCount))
			return
		countListNum -= 1
	SeedNameCountList.add_item(seedName,null,false)
	SeedNumCountList.add_item(str(seedCount),null,true)
	seedCountTypeArray.append(arrayId)

func _on_seed_num_count_list_item_selected(index: int) -> void:
	seedList.deselect_all()
	var seedName: String = SeedNameCountList.get_item_text(index)
	nameTarget = seedName
	if inputBox.value > 0:
		preventTriggerOnSeedOrTypeChange = true
		inputBox.value = 0

func _on_max_fertility_value_changed(value: float) -> void:
	maxFertility = value
