class_name BuffItemRandomizer

extends Node2D

var buffItemArray := [
	preload("res://Entities/Items/BuffingItems/BerzerkerPotion/berzerker_potion.tscn")
]

func getRandomBuff():
	var buffResource = buffItemArray[randi_range(0, buffItemArray.size() - 1)].instantiate()
	return buffResource
