extends Node2D

var dungeonSize := 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameManager.gameManagerInit($Player)
	$GameManager.startBattlePhase()



func _on_game_manager_battle_ended(entity):
	#$GameManager.removeLabels()
	dungeonSize -= 1
	print(dungeonSize)
	if dungeonSize == 8 or dungeonSize == 2:
		await $GameManager.healRoll(entity)
		#$GameManager.removeLabels()
	##TODO: Fix Shop
	##if dungeonSize == 6 or dungeonSize == 4:
		##await $GameManager.shop(entity)
		#$GameManager.removeLabels()
	if dungeonSize == 5:
		await $GameManager.item_drop(entity)
		#$GameManager.removeLabels()
	if dungeonSize == 1:
		$GameManager.gameManagerInit(entity, true)
		#$GameManager.removeLabels()
		$GameManager.startBattlePhase()
	elif dungeonSize > 1:
		$GameManager.gameManagerInit(entity)
		#$GameManager.removeLabels()
		$GameManager.startBattlePhase()
	else:
		$GameManager.addLabel("Game over! You win!!", $GameManager.mainLabel)
