extends Control

var versionName: String = "Version: Rewrite 0.1"
var version: float = 0.1
@export var versionLabel: Label

const Fiber: Dictionary = {"Cotton" = 2.0}
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


var addingFromSeedMenu: bool = false
var editingValue: bool = false
var swappingSelfContained: bool = false
var swapping: bool = false
var swapOriginIndex: int = -1
var swapTargetIndex: int = -1
var swapTargetArray: Array = []
var swapOriginArray: Array = []


const staticTestDic: Dictionary = {
	"Fiber" = Fiber, "Flowers" = Flowers,"Fruit" = Fruit,"Grass" = Grass,"Herb" = Herb,
	"Mushroom" = Mushroom,"Nuts" = Nuts,"Ornamental" = Ornamental,
	"Pasture" = Pasture,"Straw" = Straw,"Trees" = Trees,"Vegetable" = Vegetable,
}
var testDic: Dictionary = {}

const typeNameArray: Array[String] = ["Fiber","Flowers","Fruit","Grass","Herb","Mushroom","Nuts","Ornamental",
	"Pasture","Straw","Trees","Vegetable",]
var menuTypeName: String = "No Target"
var seedName: String = "No Target"
var typeId: int = -1
var currentSeeds: Array = []
var amount: float = 0.0
var seedCheckerIndex: int = -1

var maxFertility: float = 120.0:
	set(newCost):
		maxFertility = newCost
		updateFertilityLabels()
var fertilityCost: float = 0.0:
	set(newCost):
		fertilityCost = newCost
		updateFertilityLabels()

@export var fertilityDifferenceLabel: Label

@export var typeMenu: ItemList
@export var seedsMenu: ItemList
@export var seedNameList: ItemList
@export var seedAmountList: ItemList

var inputBox: SpinBox = null

func _ready() -> void:
	typeMenu.clear()
	for key in typeNameArray:
		typeMenu.add_item(key,null,true)
	if versionLabel:
		versionLabel.text = versionName

#not tested
func _on_type_menu_item_selected(index: int) -> void:
	menuTypeName = typeNameArray[index]
	deselectAll()
	typeId = index
	seedName = "No Target"
	if typeMenu.item_count > 0:
		seedsMenu.clear()
	for key in staticTestDic[menuTypeName]:
		seedsMenu.add_item(key,null,true)
	removeOldInputBox()
#not tested
func _on_seed_menu_item_selected(index: int) -> void:
	amount = 0.0
	removeOldInputBox()
	seedName = seedsMenu.get_item_text(index)
	if swapping:
		if not checkIfEntryExists():
			swapItem(index)
			calculateCost()
			return
		resetSwapping()
		return
	createInputBox(amount)
#maybe done, not tested
func _on_current_seeds_item_selected(index: int) -> void:
	removeOldInputBox()
	editingValue = false
	if swapping == true:
		swapTargetIndex = index
		swappingSelfContained = true
		swapItem(index)
		return
	swapOriginIndex = index
	swapping = true
#not tested
func _on_seed_ammount_item_selected(index: int) -> void:
	removeOldInputBox()
	editingValue = true
	swapping = false
	swappingSelfContained = false
	seedCheckerIndex = index
	amount = currentSeeds[index]["Amount"]
	createInputBox(amount)

func checkIfEntryExists():
	if testDic.has(menuTypeName):
		if testDic[menuTypeName].has(seedName):
			var thisIndex: int = 0
			seedCheckerIndex = -1
			for i in currentSeeds:
				if i.has(menuTypeName) && i.has(seedName):
					seedCheckerIndex = thisIndex
					editingValue = true
					return true
				thisIndex += 1
	return false

func addToDicAndArray(type: String,seed: String,value: float,):
	if not testDic.has(type):
		testDic[type] = {}
	if not testDic[type].has(seed):
		testDic[type][seed] = value
	var thisIndex: int = 0
	seedCheckerIndex = -1
	for i in currentSeeds:
		if i.has(type) && i.has(seed):
			print("already exists in array as index ",thisIndex)
			seedCheckerIndex = thisIndex
			return
		thisIndex += 1
	if not swapping:
		currentSeeds.append({"Type" = type, "Seed" = seed,"Amount" = value})
		var seedsize = currentSeeds.size()
		if seedsize > 0:
			seedCheckerIndex = seedsize - 1
		seedAmountList.add_item(str(value),null,true)
		seedNameList.add_item(seed,null,true)
		addingFromSeedMenu = false
		editingValue = true
	return

func editDicAndArray(value: int):
	var tempType: String
	var tempSeed: String
	var tpId: int = seedCheckerIndex
	if currentSeeds[tpId]:
		tempType = currentSeeds[tpId]["Type"]
		tempSeed = currentSeeds[tpId]["Seed"]
		currentSeeds[tpId]["Amount"] = value
		testDic[tempType][tempSeed] = value
		seedAmountList.set_item_text(tpId,str(value))
		return
	print("Array does not exist, edit func.")
func removeFromDicAndArray(index: int):
	if currentSeeds[index]:
		var tempType: String = currentSeeds[index]["Type"]
		var tempSeed: String = currentSeeds[index]["Seed"]
		if testDic.has(tempType):
			var sizE = testDic[tempType].size()
			if sizE == 1:
				testDic.erase(tempType)
			if sizE > 1:
				testDic[tempType].erase(tempSeed)
		if not swapping:
			currentSeeds.remove_at(index)
	editingValue = false
	pass
func swapItem(index: int):
	#works for internal swapping. no need for anything else for internal swap.
	if swappingSelfContained:
		var ins:int = 0
		#the "for key in currentSeeds[swapTargetIndex]" the index does not matter since they all have same keys
		for key in currentSeeds[swapTargetIndex]:
			swapTargetArray.append(currentSeeds[swapTargetIndex][key])
			swapOriginArray.append(currentSeeds[swapOriginIndex][key])
		for key in currentSeeds[swapTargetIndex]:
			currentSeeds[swapTargetIndex][key] = swapOriginArray[ins]
			currentSeeds[swapOriginIndex][key] = swapTargetArray[ins]
			ins += 1
		resetSwapping()
		updateItemLists(-1)
		return
	if swapping:
		var tempName: String = seedNameList.get_item_text(index)
		var tempAmount: float = currentSeeds[swapOriginIndex]["Amount"]
		addToDicAndArray(menuTypeName,tempName,tempAmount)
		removeFromDicAndArray(swapOriginIndex)
		currentSeeds[swapOriginIndex]["Seed"] = seedName
		currentSeeds[swapOriginIndex]["Type"] = menuTypeName
		seedNameList.set_item_text(swapOriginIndex,seedName)
		resetSwapping()
		pass
func updateItemLists(index: int):
	if index > -1:
		seedNameList.remove_item(index)
		seedAmountList.remove_item(index)
	if index < 0:
		seedNameList.clear()
		seedAmountList.clear()
		for item in currentSeeds:
			seedNameList.add_item(item["Seed"],null,true)
			seedAmountList.add_item(item["Amount"],null,true)
func calculateCost():
	var vals: float = 0.0
	for types in testDic:
		for keys in testDic[types]:
			vals += testDic[types][keys] * staticTestDic[types][keys]
	fertilityCost = vals

func createInputBox(value: float,):
	removeOldInputBox()
	inputBox = SpinBox.new()
	var mousePos: Vector2 = get_global_mouse_position()
	mousePos = Vector2(clampf(mousePos.x,30,550),clampf(mousePos.y,30,400))
	self.add_child(inputBox)
	inputBox.global_position = mousePos
	inputBox.rounded = true
	inputBox.editable = true
	inputBox.alignment = HORIZONTAL_ALIGNMENT_RIGHT
	inputBox.min_value = 0.0
	inputBox.max_value = 10000.0
	inputBox.step = 1.0
	if value > 0.0:
		inputBox.value = value
	#below value, above update changed
	inputBox.update_on_text_changed = true
	inputBox.connect("value_changed", Callable(self, "numberBox"))

func numberBox(value: float):
	if value > 0.0:
		if editingValue == true:
			editDicAndArray(value)
			calculateCost()
			return
			pass
			pass
		if addingFromSeedMenu == true:
			if not checkIfEntryExists():
				addToDicAndArray(menuTypeName,seedName,value)
				calculateCost()
				return
				pass
				pass
	if value == 0.0:
		if checkIfEntryExists():
			removeFromDicAndArray(seedCheckerIndex)
			editingValue = false
			calculateCost()
			updateItemLists(seedCheckerIndex)
			removeOldInputBox()
			deselectAll()

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

func removeOldInputBox():
	if inputBox:
		inputBox.queue_free()
		return

func deselectAll():
	seedsMenu.deselect_all()
	seedAmountList.deselect_all()
	seedNameList.deselect_all()

func resetSwapping():
	swapping = false
	swappingSelfContained = false
	if swapTargetArray:
		swapTargetArray.clear()
	if swapOriginArray:
		swapOriginArray.clear()
	swapTargetIndex = -1
	swapOriginIndex = -1
	deselectAll()
	pass
