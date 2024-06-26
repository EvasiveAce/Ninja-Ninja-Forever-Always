class_name Entity

extends Node2D

@export var characterName : String
@export var inventory : InventoryComponent

func attackRoll():
	var damageToDeal := 0
	damageToDeal += inventory.inventoryArray[0].roll()
	return damageToDeal
