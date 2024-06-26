extends Node2D

var battlesWon := 0 

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameManager.gameManagerInit($Player)
	$GameManager.startBattlePhase()



func _on_game_manager_battle_ended(entity):
	$GameManager.gameManagerInit(entity)
	$GameManager.startBattlePhase()
