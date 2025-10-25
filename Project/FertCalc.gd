extends Control

#save and load system
#ui work


const versionName: String = "Version: 1.0"
const version: float = 1.0
@export var versionLabel: Label

const typeNameVersion: float = 1.0
const seedNameVersion: float = 1.0


const Fiber: Dictionary = {"Cotton" = 2.0}
const Flowers: Dictionary = {"Normal Flower" = 1.0,"Blue Flower" = 1.0,"Sunflower" = 1.2,"Tulip" = 1.4,
"White Flower" = 1.0,"Yellow Flower" = 1.0}
const Fruit: Dictionary = {"Apple" = 3.0,"Banana" = 2.0,"Berry" = 1.0,"Cactus" = 3.0,"Grape" = 5.0,
"Orange" = 3.0,"Palulu" = 2.0,"Pear" = 3.0,"Rainbow" = 8.0}
const Grass: Dictionary = {"Weed" = 1.0,"Cattail" = 1.0}
const Herb: Dictionary = {"Blue Herb" = 2.0, "Green Herb" = 2.0,"Purple Herb" = 2.0,"Red Herb" = 2.0,
"Tobacc" = 6.0}
const Mushroom: Dictionary = {"Mushroom" = 2.0}
const Nuts: Dictionary = {"Api" = 2.0,"Coffee" = 4.0,"Crim" = 2.0}
const Ornamental: Dictionary = {"Rafflesia" = 0.0,"Fern" = 0.0}
const Pasture: Dictionary = {"Pasture" = 0.5,"Silver" = 0.5}
const Straw: Dictionary = {"Rice" = 3.0,"Wheat" = 3.0}
const Trees: Dictionary = {"Birch" = 0.5,"Cedar" = 0.5,"Cherry" = 0.5,"Christmas" = 0.5,"Coral" = 7.0,
"Feywood" = 10.0,"Fir" = 0.5,"Mushroom Tree" = 0.5,"Mahogany" = 0.5,"Oak" = 0.5,"Pine" = 0.5,"Rosewood" = 0.5,}
const Vegetable: Dictionary = {"Bamboo" = 1.0,"Cabbage" = 4.0,"Cabocchi" = 4.0,"Carrot" = 3.0,
"Corn" = 4.0,"Imo" = 3.0,"Radish" = 4.0,"Red Pepper" = 6.0,"SeaweedDeep" = 4.0,"Tomato" = 3.0,}


var addingFromSeedMenu: bool = false
var editingValue: bool = false
var swappingSelfContained: bool = false
var swapping: bool = false
var swapOriginIndex: int = -1
var swapTargetIndex: int = -1
var swapTargetArray: Array = []
var swapOriginArray: Array = []

var resetAble:bool = false

const seedNameArray: Array[String] = ["Cotton", "Normal Flower", "Blue Flower", "Sunflower", "Tulip",
 "White Flower","Yellow Flower", "Apple", "Banana", "Berry", "Cactus", "Grape", "Orange", "Palulu", "Pear",
 "Rainbow", "Weed", "Cattail","Blue Herb","Green Herb", "Purple Herb","Red Herb", "Tobacc", "Mushroom", "Api",
 "Coffee", "Crim", "Rafflesia", "Fern", "Pasture", "Silver","Rice", "Wheat", "Birch", "Cedar", "Cherry",
"Christmas", "Coral", "Feywood", "Fir", "Mushroom Tree","Mahogany", "Oak", "Pine","Rosewood","Bamboo",
"Cabbage","Cabocchi","Carrot","Corn","Imo","Radish","Red Pepper","SeaweedDeep","Tomato"]

const typeNameArray: Array[String] = ["Fiber","Flowers","Fruit","Grass","Herb","Mushroom","Nuts","Ornamental",
	"Pasture","Straw","Trees","Vegetable",]

const staticTestDic: Dictionary = {
	"Fiber" = Fiber, "Flowers" = Flowers,"Fruit" = Fruit,"Grass" = Grass,"Herb" = Herb,
	"Mushroom" = Mushroom,"Nuts" = Nuts,"Ornamental" = Ornamental,
	"Pasture" = Pasture,"Straw" = Straw,"Trees" = Trees,"Vegetable" = Vegetable,
}
var testDic: Dictionary = {}

var menuTypeName: String = "No Target"
var seedName: String = "No Target"
var typeId: int = -1
var currentSeeds: Array = []
var amount: float = 0.0
var seedCheckerIndex: int = -1

const sLPopTime: float = 2.0

var maxFertility: float = 120.0:
	set(newCost):
		maxFertility = newCost
		maximumFertilityLabel.text = str(int(maxFertility))
		updateFertilityLabels()
var fertilityCost: float = 0.0:
	set(newCost):
		fertilityCost = newCost
		updateFertilityLabels()

@export var fertilityDifferenceLabel: Label
@export var maximumFertilityLabel: Label

@export var typeMenu: ItemList
@export var seedsMenu: ItemList
@export var seedNameList: ItemList
@export var seedAmountList: ItemList

@export var resetSafetyButton: CheckButton
@export var resetButton: Button

@export var loadLine: LineEdit
@export var saveLoadList: ItemList

@export var slPopupParent: Control
@export var slPopupTimer: Timer
var inputBox: SpinBox = null
var slPopup: Label = null

var seedClass: seedCostsC

const save_path = "user://my_save_data.txt"

@export var maxFertSpinbox: SpinBox
var loadMaxFert: bool = false
func _ready() -> void:
	seedClass = seedCostsC.new()
	if FileAccess.file_exists(save_path):
		var a = FileAccess.open(save_path,FileAccess.READ)
		var b = a.get_var(false)
		if checkLoadInfo(b):
			loadStats(b)
		a.close()
	closeLoadWin()
	typeMenu.clear()
	for key in typeNameArray:
		typeMenu.add_item(key,null,true)
	if versionLabel:
		versionLabel.text = versionName
	updateFertilityLabels()


func _on_type_menu_item_selected(index: int) -> void:
	closeLoadWin()
	menuTypeName = typeNameArray[index]
	deselectAll()
	typeId = index
	seedName = "No Target"
	if typeMenu.item_count > 0:
		seedsMenu.clear()
	for key in staticTestDic[menuTypeName]:
		seedsMenu.add_item(key,null,true)
	removeOldInputBox()

func _on_seed_menu_item_selected(index: int) -> void:
	closeLoadWin()
	seedAmountList.deselect_all()
	editingValue = false
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
	if not checkIfEntryExists():
		addingFromSeedMenu = true
	else:
		amount = currentSeeds[seedCheckerIndex]["Amount"]
	createInputBox(amount)

func _on_current_seeds_item_selected(index: int) -> void:
	closeLoadWin()
	seedAmountList.deselect_all()
	seedsMenu.deselect_all()
	removeOldInputBox()
	editingValue = false
	if swapping == true:
		swapTargetIndex = index
		swappingSelfContained = true
		swapItem(index)
		return
	swapOriginIndex = index
	swapping = true

func _on_seed_ammount_item_selected(index: int) -> void:
	closeLoadWin()
	seedsMenu.deselect_all()
	seedNameList.deselect_all()
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
				print(i)
				if i["Type"] == menuTypeName && i["Seed"] == seedName:
					seedCheckerIndex = thisIndex
					editingValue = true
					return true
				thisIndex += 1
	return false

func addToDicAndArray(type: String,seedN: String,value: float,):
	if not testDic.has(type):
		testDic[type] = {}
	if not testDic[type].has(seedN):
		testDic[type][seedN] = value
	var thisIndex: int = 0
	seedCheckerIndex = -1
	for i in currentSeeds:
		if i.has(type) && i.has(seedN):
			print("already exists in array as index ",thisIndex)
			seedCheckerIndex = thisIndex
			return
		thisIndex += 1
	if not swapping:
		currentSeeds.append({"Type" = type, "Seed" = seedN,"Amount" = value})
		var seedsize = currentSeeds.size()
		if seedsize > 0:
			seedCheckerIndex = seedsize - 1
		seedAmountList.add_item(str(value),null,true)
		seedNameList.add_item(seedN,null,true)
		addingFromSeedMenu = false
		editingValue = true
	return

func editDicAndArray(value: float):
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
func swapItem(_index: int):
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
		var tempAmount: float = currentSeeds[swapOriginIndex]["Amount"]
		addToDicAndArray(menuTypeName,seedName,tempAmount)
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
			seedAmountList.add_item(str(item["Amount"]),null,true)
func calculateCost():
	var vals: float = 0.0
	for types in testDic:
		for keys in testDic[types]:
			vals += testDic[types][keys] * staticTestDic[types][keys]
	if loadMaxFert:
		var mV: float = maxFertSpinbox.max_value
		var cMinV: float = clampf(maxFertility,100.0,mV)
		var roundingVal: float = clampf(vals + 1.0,cMinV,mV)
		var newValue: float = int(roundingVal)
		maxFertSpinbox.value = newValue
		loadMaxFert = false
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
		if addingFromSeedMenu == true:
			if not checkIfEntryExists():
				addToDicAndArray(menuTypeName,seedName,value)
				calculateCost()
				return
	if value == 0.0:
		if editingValue:
			removeFromDicAndArray(seedCheckerIndex)
			editingValue = false
			calculateCost()
			updateItemLists(seedCheckerIndex)
			removeOldInputBox()
			deselectAll()
			return

func updateFertilityLabels():
	var newFertDif: float = maxFertility - fertilityCost
	newFertDif = snappedf(newFertDif,0.1)
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

func resetting(ableToReset: bool):
	if ableToReset:
		addingFromSeedMenu = false
		editingValue = false
		swappingSelfContained = false
		swapping = false
		swapOriginIndex = -1
		swapTargetIndex = -1
		swapTargetArray.clear()
		swapOriginArray.clear()
		testDic.clear()
		menuTypeName = "No Target"
		seedName = "No Target"
		typeId = -1
		currentSeeds.clear()
		amount = 0.0
		seedCheckerIndex = -1
		seedNameList.clear()
		seedAmountList.clear()
		seedsMenu.clear()
		fertilityCost = 0
		deselectAll()
		typeMenu.deselect_all()
		removeOldInputBox()
		resetAble = false
		resetSafetyButton.button_pressed = false
		resetButton.release_focus()
		closeLoadWin()
		return

func _on_reset_safety_toggled(toggled_on: bool) -> void:
	resetAble = toggled_on

func _on_reset_button_button_up() -> void:
	resetting(resetAble)

func _on_max_fert_spin_box_value_changed(value: float) -> void:
	maxFertility = value

func checkLoadInfo(loadString: String) -> bool:
	var vas = JSON.new()
	var error = vas.parse(loadString)
	if error != 0:
		loadLine.clear()
		slPopupFunc("Not Json Parsable.", sLPopTime)
		return false
	var tA = JSON.parse_string(loadString)
	if tA is not Array:
		loadLine.clear()
		slPopupFunc("Wrong Format, not an array.", sLPopTime)
		return false
	var tas = tA.size()
	if tas == 0:
		loadLine.clear()
		slPopupFunc("Empty Load Info.", sLPopTime)
		return false
	if tas != 2:
		loadLine.clear()
		slPopupFunc("Load info does not contain 2 arrays,
		 e.g [[versions numbers e.g 1.0,1.0][seeds info]].", 10.0)
		return false
	if tA[0] is not Array:
		loadLine.clear()
		slPopupFunc("Wrong Format, item 1 is not an array.", sLPopTime)
		return false
	if tA[1] is not Array:
		loadLine.clear()
		slPopupFunc("Wrong Format, item 2 is not an array.", sLPopTime)
		return false
	if tA[0].size() != 2:
		loadLine.clear()
		slPopupFunc("Version Array has more or fewer items than 2.", sLPopTime)
		return false
	if tA[1].size() < 3:
		loadLine.clear()
		slPopupFunc("Seed Array items less than 3.", sLPopTime)
		return false
	if tA[0][0] is not float && tA[0][1] is not float:
		loadLine.clear()
		slPopupFunc("One or both version numbers is not a float, e.g 1.0", sLPopTime)
		return false
	if tA[0][0] < 1.0 or tA[0][1] < 1.0:
		loadLine.clear()
		slPopupFunc("One or both version numbers are incorrect.", sLPopTime)
		return false
	if tA[1].size() % 3 != 0:
		loadLine.clear()
		slPopupFunc("Wrong amount of items in second array, not divisable by 3.", sLPopTime)
		return false
	for item in tA[1]:
		if item is not float:
			loadLine.clear()
			slPopupFunc("One or more items in array 2, are not float numbers. e.g 1.0, 2.0, 3.0", sLPopTime)
			return false
		if item < 0.0:
			loadLine.clear()
			slPopupFunc("One of the values in array 2 is negative.",sLPopTime)
	var chkbool: Array = seedClass.chkDics(tA[0][0],tA[0][1])
	var nameBoolChk: bool = chkbool[0]
	var typeBoolChk: bool = chkbool[1]
	if !nameBoolChk:
		if !typeBoolChk:
			loadLine.clear()
			slPopupFunc("Both version numbers are not valid.", sLPopTime)
			return false
		loadLine.clear()
		slPopupFunc("First version number is not valid.",sLPopTime)
		return false
	if !typeBoolChk:
		loadLine.clear()
		slPopupFunc("Second version number is not valid.", sLPopTime)
		return false
	return true

func loadStats(loadString: String):
	var vit: Array[float]
	var i: int = 0
	var tA: Array = JSON.parse_string(loadString)
	var tas = tA[1].size()
	var tmpSeedNA: Array = seedClass.getSeedN(tA[0][0])
	var tmpTypeNA: Array = seedClass.getTypeN(tA[0][1])
	var tNAS = tmpTypeNA.size() - 1
	var sNAS = tmpSeedNA.size() - 1
	currentSeeds.clear()
	testDic.clear()
	seedNameList.clear()
	seedAmountList.clear()
	while i < tas:
		vit.append(clampf(tA[1][i],1.0,10000.0))
		i += 1
	var tempTypeId: int = 0
	var tempNameId: int = 1
	var tempAmountId: int = 2
	var iterations: int = tas / 3
	var currentIteration: int = 0
	#typeint, seedint, amountint, 0,1,2, += 3
	var typeExist: bool = false
	var seedExist: bool = false
	while currentIteration < iterations:
		var saveTypeInt = int(vit[tempTypeId])
		var saveNameInt = int(vit[tempNameId])
		var tempAmount: float = vit[tempAmountId]
		var tempType: String
		var tempSeed: String
		if tempAmount >= 1.0:
			if saveTypeInt <= tNAS:
				tempType = tmpTypeNA[saveTypeInt]
				typeExist = true
			if saveNameInt <= sNAS:
				tempSeed = tmpSeedNA[saveNameInt]
				seedExist = true
			if typeExist && seedExist:
				if staticTestDic.has(tempType):
					if staticTestDic[tempType].has(tempSeed):
						addToDicAndArray(tempType,tempSeed,tempAmount)
		tempTypeId += 3
		tempNameId += 3
		tempAmountId += 3
		typeExist = false
		seedExist = false
		currentIteration += 1
	loadMaxFert = true
	calculateCost()
	closeLoadWin()
	slPopupFunc("Loaded", sLPopTime)

func saveStats() -> void:
	var si = currentSeeds.size()
	if si <= 0:
		slPopupFunc("Nothing to save.", 1.5)
		return
	var saveInfo: Array = [[],[]]
	var iterationNumber: int = 0
	var maxIterations: int = currentSeeds.size()
	saveInfo[0].append(seedNameVersion)
	saveInfo[0].append(typeNameVersion)
	while iterationNumber < maxIterations:
		var itType: String = currentSeeds[iterationNumber]["Type"]
		var itSeed: String = currentSeeds[iterationNumber]["Seed"]
		var tpNum: int = typeNameArray.find(itType)
		var sdNum: int = seedNameArray.find(itSeed)
		if tpNum < 0:
			return
		if sdNum < 0:
			return
		saveInfo[1].append(tpNum)
		saveInfo[1].append(sdNum)
		saveInfo[1].append(currentSeeds[iterationNumber]["Amount"])
		iterationNumber += 1
	var infoString: String = str(saveInfo)
	if saveInfo[1].size() > 0:
		DisplayServer.clipboard_set(infoString)
		saveLoadList.release_focus()
		slPopupFunc("Copied to ClipBoard", sLPopTime)
		var s = FileAccess.open(save_path,FileAccess.WRITE)
		s.store_var(infoString,false)
		s.close()
		return
	else:
		slPopupFunc("Could Not Successfully save info.", sLPopTime)
		return

func _on_save_load_list_item_selected(index: int) -> void:
	removeOldInputBox()
	var tempString: String = saveLoadList.get_item_text(index)
	if tempString == "Save":
		closeLoadWin()
		if currentSeeds:
			saveStats()
		saveLoadList.deselect_all()
		return
	if tempString == "Load":
		loadLine.clear()
		loadLine.show()
		saveLoadList.deselect_all()
		loadLine.grab_focus()
		return

func _on_load_line_text_submitted(load_text: String) -> void:
	removeOldInputBox()
	if !seedClass:
		seedClass = seedCostsC.new()
	if load_text:
		var a: bool = checkLoadInfo(load_text)
		if a == false:
			loadLine.clear()
			return
		
		loadStats(load_text)

func slPopupFunc(text: String,time: float):
	if slPopup:
		slPopup.queue_free()
	slPopup = Label.new()
	slPopupParent.add_child(slPopup)
	slPopup.set_position(Vector2(0,0))
	slPopup.add_theme_color_override("font_shadow_color",Color.BLACK)
	slPopup.text = text
	slTimer(time)

func slTimer(time: float):
	if slPopupTimer:
		slPopupTimer.stop()
		slPopupTimer.one_shot = true
		slPopupTimer.start(time)
func _on_sl_popup_timer_timeout() -> void:
	if slPopup:
		slPopup.queue_free()

func closeLoadWin() -> void:
	if loadLine.visible == true:
		loadLine.clear()
		loadLine.hide()
