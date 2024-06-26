class_name EnemyRandomizer

extends Node2D

var enemyArray := [
	preload("res://Scenes/potatomous.tscn"),
	preload("res://Scenes/nose_goblin.tscn")
]

func getRandomEnemy():
	var enemy = enemyArray[randi_range(0, enemyArray.size() - 1)].instantiate()
	enemy.name = "ENEMY "
	return enemy
