class_name PassiveItemRandomizer

extends Node2D

var passiveItemArray := [
	preload("res://Scenes/Items/Passives/rabbit's_foot.tscn")
]

func getRandomPassive():
	var passiveResource = passiveItemArray[randi_range(0, passiveItemArray.size() - 1)].instantiate()
	return passiveResource
