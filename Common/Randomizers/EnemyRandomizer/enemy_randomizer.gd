class_name EnemyRandomizer

extends Node2D

var enemyArray := [
	preload("res://Entities/Enemies/Potatomous/potatomous.tscn"),
	preload("res://Entities/Enemies/NoseGoblin/nose_goblin.tscn")
]

var bossArray := [
	preload("res://Entities/Enemies/SantaClaus/santa_claus.tscn")
]

func getRandomEnemy():
	var enemy = enemyArray[randi_range(0, enemyArray.size() - 1)].instantiate()
	enemy.name = "ENEMY "
	return enemy

func getBossEnemy():
	var boss = bossArray[randi_range(0, enemyArray.size() - 1)].instantiate()
	boss.name = "BOSS "
	return boss
