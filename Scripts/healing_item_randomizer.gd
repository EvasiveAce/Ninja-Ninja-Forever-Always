class_name HealingItemRandomizer

extends Node2D

var healingItemArray := [
	preload("res://Scenes/Items/Healing/healing_orb.tscn"),
	preload("res://Scenes/Items/Healing/healing_potion.tscn")
]

func getRandomHealing():
	var healingResource = healingItemArray[randi_range(0, healingItemArray.size() - 1)].instantiate()
	return healingResource
