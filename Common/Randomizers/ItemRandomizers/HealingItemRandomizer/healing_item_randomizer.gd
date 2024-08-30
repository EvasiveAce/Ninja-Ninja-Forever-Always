class_name HealingItemRandomizer

extends Node2D

var healingItemArray := [
	preload("res://Entities/Items/HealingItems/HealingPotion/healing_potion.tscn"),
	preload("res://Entities/Items/HealingItems/HealingOrb/healing_orb.tscn")
]

func getRandomHealing():
	var healingResource = healingItemArray[randi_range(0, healingItemArray.size() - 1)].instantiate()
	return healingResource
