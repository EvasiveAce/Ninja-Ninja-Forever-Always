extends Node2D

var dungeonSize := 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameManager.gameManagerInit($Player)
	$GameManager.startBattlePhase()



func _on_game_manager_battle_ended(entity):
	$GameManager.removeLabels()
	dungeonSize -= 1
	print(dungeonSize)
	if dungeonSize == 8 or dungeonSize == 2:
		await $GameManager.healRoll(entity)
		$GameManager.removeLabels()
	if dungeonSize == 9 or dungeonSize == 4:
		await $GameManager.shop(entity)
		$GameManager.removeLabels()
	$GameManager.gameManagerInit(entity)
	$GameManager.removeLabels()
	$GameManager.startBattlePhase()
