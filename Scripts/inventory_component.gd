class_name InventoryComponent

extends Node2D

@export var inventorySize : int

var inventoryArray : Array[Dice] = []

func add(dice : Dice):
	if inventoryArray.size() >= inventorySize:
		print("Inventory is Full")
		return null
	inventoryArray.push_back(dice)
	#print(dice.diceName + " has been added to your Inventory")

