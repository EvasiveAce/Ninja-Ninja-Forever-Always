class_name Entity

extends Node2D

@export var characterName : String

@export var inventory : InventoryComponent

func attackRoll():
	var damageToDeal := 0
	for dice in inventory.inventoryArray:
		damageToDeal += dice.roll()
	return damageToDeal
