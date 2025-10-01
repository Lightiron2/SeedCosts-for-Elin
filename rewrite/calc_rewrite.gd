extends Control

func _ready() -> void:
	var existCheck = {"vas" = {"des" = 2}}
	if existCheck.has(menuTypeName):
		if existCheck[menuTypeName].has(seedName):
			pass
	#seed menu swap requires only oriArray and oriId, keep the old seed+type for editing dic func.
	#seed menu swap changes the type and seed, save type+seed for dic add/remove.
	#amount list dosent need to be called.
	#create a checker for if the seedmenu seed already exists in the current seeds and dic.
	pass
	pass
	pass

#to be code
#currentSeeds.append({"Type" = menuTypeName, "Seed" = seedName,"Amount" = amount})
#var cSeeds: Array = currentSeeds
#if not testDic[cSeeds[0]["Type"]:
#	testDic[cSeeds[0]["Type"] = {}
#testDic[cSeeds[0]["Type"]][cSeeds[0]["Seed"] = cSeeds[0]["Amount"]
#calculateCost()

#var curArNum: int = currentSeeds.size()
#if value == 0:
#	array.erase curArNum
#	if testDic[cSeeds[curArNum]["Type"]].size() =< 1:
#		testDic.erase(cSeeds[curArNum]["Type"])
#	else:
#		testDic[cSeeds[curArNum]["Type"][cSeeds[curArNum]["Seed"]]
#

#var temp: Dictionary = currentSeeds[index]
#var tempTarget: Dictionary = currentseeds[targetId]
#currentSeeds[index] = tempTarget
#currentSeeds[targetId] = temp
#calculateCost()
var addingFromSeedMenu: bool = false
var editingValue: bool = false
var swappingSelfContained: bool = false
var swapping: bool = false
var swapOriginIndex: int = -1
var swapTargetIndex: int = -1
var swapTargetArray: Array = []
var swapOriginArray: Array = []



const staticTestDic: Dictionary = {
	"flow" = {"white" = 1, "normal" = 1},
	"tree" = {"fat" = 5, "skinny" = 1}
}
var testDic: Dictionary = {}
const testArray: Array = ["flow","tree"]
var typeNameArray: Array = ["flow","tree"]
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
@export var seedAmmountList: ItemList

var inputBox: SpinBox = null

func _on_type_menu_item_selected(index: int) -> void:
	menuTypeName = typeNameArray[index]
	seedAmmountList.deselect_all()
	seedsMenu.deselect_all()
	typeId = index
	seedName = "No Target"
	if typeMenu.item_count > 0:
		seedsMenu.clear()
	for key in staticTestDic[menuTypeName]:
		seedsMenu.add_item(key,null,true)
	removeOldInputBox()

func _on_seed_menu_item_selected(index: int) -> void:
	amount = 0.0
	removeOldInputBox()
	seedName = seedsMenu.get_item_text(index)
	if testDic.has(menuTypeName):
		if testDic[menuTypeName].has(seedName):
			editingValue = true
			amount = testDic[menuTypeName][seedName]["Amount"]
			createInputBox(amount)
			return
			pass
			pass
	createInputBox(0.0)

func _on_current_seeds_item_selected(index: int) -> void:
	removeOldInputBox()
	if swapping == true:
		swappingSelfContained = true
#		swapItem(index)
		return
	#swapOrigin = currentSeeds[index]
	#swapOrigin["Index"] = index
	swapping = true

func _on_seed_ammount_item_selected(index: int) -> void:
	removeOldInputBox()
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
	currentSeeds.append({"Type" = type, "Seed" = seed,"Amount" = value})
	var seedsize = currentSeeds.size()
	if seedsize > 0:
		seedCheckerIndex = seedsize - 1
	seedAmmountList.add_item(str(value),null,true)
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
		seedAmmountList.set_item_text(tpId,str(value))
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
		swapTargetArray.clear()
		swapOriginArray.clear()
		swapTargetIndex = -1
		swapOriginIndex = -1
		deselectAll()
		swappingSelfContained = false
		updateItemLists(-1)
func updateItemLists(index: int):
	if index > -1:
		seedNameList.remove_item(index)
		seedAmmountList.remove_item(index)
	if index < 0:
		seedNameList.clear()
		seedAmmountList.clear()
		for item in currentSeeds:
			seedNameList.add_item(item["Seed"],null,true)
			seedAmmountList.add_item(item["Amount"],null,true)
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
	seedAmmountList.deselect_all()
	seedNameList.deselect_all()
