extends Control

var versionName: String = "Version: Something 0.00"
var version: float = 0.001
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


var FiberChosen: Dictionary = {"Cotton" = 0.0}
var FlowersChosen: Dictionary = {"Normal" = 0.0,"Blue" = 0.0,"White" = 0.0,"Yellow" = 0.0}
var FruitChosen: Dictionary = {"Apple" = 0.0,"Banana" = 0.0,"Berry" = 0.0,"Cactus" = 0.0,"Grape" = 0.0,
"Orange" = 0.0,"Palulu" = 0.0,"Pear" = 0.0,"Rainbow" = 0.0}
var GrassChosen: Dictionary = {"Weed" = 0.0,"Cattail" = 0.0}
var HerbChosen: Dictionary = {"Blue" = 0.0, "Green" = 0.0,"Purple" = 0.0,"Red" = 0.0,"Tobacc" = 0.0}
var MushroomChosen: Dictionary = {"Mushroom" = 0.0}
var NutsChosen: Dictionary = {"Api" = 0.0,"Coffee" = 0.0,"Crim" = 0.0}
var OrnamentalChosen: Dictionary = {"Rafflesia" = 0.0,"Fern" = 0.0}
var PastureChosen: Dictionary = {"Pasture" = 0.0,"Silver" = 0.0}
var StrawChosen: Dictionary = {"Rice" = 0.0,"Wheat" = 0.0}
var TreesChosen: Dictionary = {"Birch" = 0.0,"Cedar" = 0.0,"Cherry" = 0.0,"Christmas" = 0.0,"Coral" = 0.0,
"Feywood" = 0.0,"Fir" = 0.0,"Mushroom Tree" = 0.0,"Mahogany" = 0.0,"Oak" = 0.0,"Pine" = 0.0,"Rosewood" = 0.0,}
var VegetableChosen: Dictionary = {"Bamboo" = 0.0,"Cabbage" = 0.0,"Cabocchi" = 0.0,"Carrot" = 0.0,
"Corn" = 0.0,"Imo" = 0.0,"Radish" = 0.0,"SeaweedDeep" = 0.0,"Tomato" = 0.0,}



var maxFertility: float = 120.0:
	set(newCost):
		maxFertility = newCost
		updateFertilityLabels()
var fertilityCost: float = 0.0:
	set(newCost):
		fertilityCost = newCost
		updateFertilityLabels()

var cFiber: float = 0.0
var cFlowers: float = 0.0
var cFruits: float = 0.0
var cGrass: float = 0.0
var cHerbs: float = 0.0
var cMushrooms: float = 0.0
var cNuts: float = 0.0
var cOrnamentals: float = 0.0
var cPastures: float = 0.0
var cStraws: float = 0.0
var cTrees: float = 0.0
var cVegetables: float = 0.0


@export var fertilityDifferenceLabel: Label
@export var SeedNameCountList: ItemList
@export var SeedNumCountList: ItemList

@export var inputBox: SpinBox
var preventTriggerOnSeedOrTypeChange: bool = false

var resetSafetyOne: bool = false
var resetSafetyTwo: bool = false

@export var seedMenu: ItemList
@export var typeMenu: ItemList

var resetting:bool = false

var checkDicNArraySize: bool = true
const seedCostArray: Array[Dictionary] = [Fiber,Flowers,Fruit,Grass,Herb,Mushroom,Nuts,Ornamental,
	Pasture,Straw,Trees,Vegetable,]
const seedTypeNameArray: Array[String] = ["Fiber","Flowers","Fruit","Grass","Herb","Mushroom","Nuts","Ornamental",
	"Pasture","Straw","Trees","Vegetable",]
var mutableDicsArray: Array[Dictionary] = [FiberChosen,FlowersChosen,FruitChosen,GrassChosen,HerbChosen,
	MushroomChosen,NutsChosen,OrnamentalChosen,PastureChosen,StrawChosen,TreesChosen,VegetableChosen,]
var curCostArray: Array[float] = [cFiber,cFlowers,cFruits,cGrass,cHerbs,cMushrooms,cNuts,
	cOrnamentals,cPastures,cStraws,cTrees,cVegetables]
var seedCountTypeArray: Array = []

var testing: bool = false
func _ready() -> void:
	if testing:
		var testes: bool = true
		var arraySize: int = seedCostArray.size()
		if arraySize != mutableDicsArray.size():
			print("seedCost & Mutable arrays not same size")
			testes = false
		if arraySize != seedTypeNameArray.size():
			print("seedCost & seedTypeName not same size")
			testes = false
		if arraySize != curCostArray.size():
			print("seedCost & curCostArray not same size")
			testes = false
		if testes:
			for i in seedCostArray.size():
				if testes:
					var keyO = seedCostArray[i].keys()
					var keyT = mutableDicsArray[i].keys()
					keyO.sort()
					keyT.sort()
					if keyO != keyT:
						print("keys do not match: ",keyO, ":  and  :",keyT)
						testes = false
	if checkDicNArraySize:
		print(seedCostArray.size(),": seedCostArray Size")
		print(seedTypeNameArray.size(),": seedTypeNameArray Size")
		print(mutableDicsArray.size(),": mutableDicsArray Size")
		print(curCostArray.size(),": curCostArray Size")
	typeMenu.clear()
	for i in seedTypeNameArray:
		typeMenu.add_item(i,null,true)
	versionLabel.text = versionName
	SeedNumCountList.clear()
	updateFertilityLabels()

func calcFertCost(value:float):
	var newFertilityCost: float = 0.0
	newTotalCost = 0.0
	if value < 0:
		return
	if editing && not swapping:
		#adds seedcount to mutable array
		mutableDicsArray[editTypeID][nameTarget] = value
		#multiplies and adds result to var
		for key in seedCostArray[editTypeID]:
			newFertilityCost += seedCostArray[editTypeID][key] * mutableDicsArray[editTypeID][key]
		curCostArray[editTypeID] = newFertilityCost
	if !editing && not swapping:
		mutableDicsArray[typeID][nameTarget] = value
		for key in seedCostArray[typeID]:
			newFertilityCost += seedCostArray[typeID][key] * mutableDicsArray[typeID][key]
		curCostArray[typeID] = newFertilityCost
	#adds all floats in array to total cost
	for cost in curCostArray:
		newTotalCost += cost
	if swapping:
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

func _on_spin_box_value_changed(_value: float) -> void:
	if resetting:
		return
	if preventTriggerOnSeedOrTypeChange:
		preventTriggerOnSeedOrTypeChange = false
		return
#	if nameTarget == "No Target":
#		return
#	calcFertCost(value)

func _on_reset_safety_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	if index == 0:
		resetSafetyOne = !resetSafetyOne
	if index == 1:
		resetSafetyTwo = !resetSafetyTwo

func _on_reset_button_up() -> void:
	if resetSafetyOne && resetSafetyTwo == true:
		print(curCostArray, "this one")
		print(fertilityCost)
		swapping = false
		editing = false
		resetting = true
		aftrFrstAdId = -1
		customSpinBox.queue_free()
		SeedNameCountList.clear()
		SeedNumCountList.clear()
		seedCountTypeArray.clear()
		SeedNameCountList.deselect_all()
		SeedNumCountList.deselect_all()
		seedMenu.deselect_all()
		for dic in mutableDicsArray:
			for key in dic:
				dic[key] = 0.0
				if dic[key] > 0:
					print(dic[key])
		var i = curCostArray.size()
		while i > 0:
			curCostArray[i-1] = 0.0
			i -= 1
		fertilityCost = 0
#		inputBox.value = 0
		resetting = false
		print(curCostArray)

var aftrFrstAdId: int
func editOrAddToList(seedCount: float):
	if seedCount < 0:
		return
	if editing:
		if seedCount == 0:
			SeedNameCountList.remove_item(editListID)
			SeedNumCountList.remove_item(editListID)
			seedCountTypeArray.remove_at(editListID)
			return
		SeedNumCountList.set_item_text(editListID,str(seedCount))
		return
	
	if aftrFrstAdId < 0:
		SeedNameCountList.add_item(nameTarget,null,true)
		SeedNumCountList.add_item(str(seedCount),null,true)
		seedCountTypeArray.append(typeID)
		aftrFrstAdId = seedCountTypeArray.size() - 1
		return
	else:
		SeedNumCountList.set_item_text(aftrFrstAdId,str(seedCount))

func _on_seed_type_selected(index: int) -> void:
#	if inputBox.value > 0:
#		preventTriggerOnSeedOrTypeChange = true
#		inputBox.value = 0
	SeedNumCountList.deselect_all()
	seedMenu.deselect_all()
	typeID = index
	nameTarget = "No Target"
	if typeMenu.item_count > 0:
		seedMenu.clear()
	var typeDic: Dictionary = seedCostArray[index]
	for key in typeDic:
		seedMenu.add_item(key,null,true)
	if customSpinBox != null:
		customSpinBox.queue_free()

func _on_seed_selected(index: int) -> void:
	editing = false
	SeedNumCountList.deselect_all()
	nameTarget = seedMenu.get_item_text(index)
	createNumInput(get_global_mouse_position(),0.0)
#	if inputBox.value > 0:
#		preventTriggerOnSeedOrTypeChange = true
#		inputBox.value = 0

func _on_seed_num_count_list_item_selected(index: int) -> void:
	var seedNameNum: String = SeedNumCountList.get_item_text(index)
	var value:float = float(seedNameNum)
	var mousePos: Vector2 = get_global_mouse_position()
	mousePos.x = clampf(mousePos.x,0,630)
	editing = true
	editListID = index
	editTypeID = seedCountTypeArray[index]
	nameTarget = SeedNameCountList.get_item_text(index)
	seedMenu.deselect_all()
	createNumInput(mousePos,value)
	#old spinBox
#	if inputBox.value > 0:
#		preventTriggerOnSeedOrTypeChange = true
#		inputBox.value = 0

func _on_max_fertility_value_changed(value: float) -> void:
	maxFertility = value

var editing: bool = false
var customSpinBox: SpinBox = null
var typeID: int = 0
var editListID: int = 0
var editTypeID: int = 0
var nameTarget: String = "No Target"
var newTotalCost: float = 0.0
#typeID takes from browser list, editing takes from numListTypeArray
func createNumInput(mousePos: Vector2,value: float):
	if customSpinBox:
		customSpinBox.queue_free()
	aftrFrstAdId = -1
	customSpinBox = SpinBox.new()
	self.add_child(customSpinBox)
	customSpinBox.global_position = mousePos
	customSpinBox.rounded = true
	customSpinBox.editable = true
	customSpinBox.alignment = HORIZONTAL_ALIGNMENT_RIGHT
	customSpinBox.min_value = 0.0
	customSpinBox.max_value = 10000.0
	customSpinBox.step = 1.0
	customSpinBox.value = value
	#below value, above update changed
	checkIfEditSense()
	customSpinBox.update_on_text_changed = true
	customSpinBox.connect("value_changed", Callable(self, "thisone"))

func thisone(value: float):
	if resetting:
		return
	if nameTarget == "No Target":
		return
	calcFertCost(value)
	editOrAddToList(value)
	fertilityCost = newTotalCost

func checkIfEditSense():
	var itemCount = SeedNameCountList.item_count
	while itemCount > 0:
		var i = clampi(itemCount - 1,0,99)
		var s = SeedNameCountList.get_item_text(i)
		if nameTarget == s:
			var seedNameNum: String = SeedNumCountList.get_item_text(i)
			var value:float = float(seedNameNum)
			editListID = i
			editing = true
			itemCount = 0
			editTypeID = seedCountTypeArray[i]
			customSpinBox.value = value
		itemCount -= 1

var swapping: bool = false
var swapOrigin: Array = []
var swapTarget: Array = []
func _on_seed_name_count_list_item_selected(index: int) -> void:
	if customSpinBox != null:
		customSpinBox.queue_free()
	if swapping:
		addToSwapArrays(index,swapping)
		swapper()
	swapOrigin.clear()
	swapTarget.clear()
	SeedNumCountList.deselect_all()
	seedMenu.deselect_all()
	addToSwapArrays(index,swapping)
	swapping = true

func addToSwapArrays(index: int,target: bool):
	#type, name, ammount. in that order
	if !target:
		swapOrigin.append(seedCountTypeArray[index])
		swapOrigin.append(SeedNameCountList.get_item_text(index))
		swapOrigin.append(SeedNumCountList.get_item_text(index))
	else:
		swapTarget.append(seedCountTypeArray[index])
		swapTarget.append(SeedNameCountList.get_item_text(index))
		swapTarget.append(SeedNumCountList.get_item_text(index))

func swapper():
	var oriType: int = swapOrigin[0]
	var oriName: String = swapOrigin[1]
	var oriNum: float = float(swapOrigin[2])
	
	pass
