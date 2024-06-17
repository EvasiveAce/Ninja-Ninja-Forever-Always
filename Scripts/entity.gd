class_name Entity

extends Node2D

@export var characterName : String

@export var inventory : InventoryComponent
@export var max_hp := 0

var hp : int:
	set(value):
		hp = clamp(value, 0, max_hp)
	get:
		return hp

func attackRoll():
	var damageToDeal := 0
	for dice in inventory.inventoryArray:
		damageToDeal += dice.roll()
	return damageToDeal
