class_name PassiveItemRandomizer

extends Node2D

var passiveItemArray := [
	preload("res://Entities/Items/PassiveItems/RabbitsFoot/rabbit's_foot.tscn"),
	preload("res://Entities/Items/PassiveItems/WeddingRing/wedding_ring.tscn"),
	preload("res://Entities/Items/PassiveItems/CrownOfThorns/crown_of_thorns.tscn")
]

func getRandomPassive():
	var passiveResource = passiveItemArray[randi_range(0, passiveItemArray.size() - 1)].instantiate()
	return passiveResource
