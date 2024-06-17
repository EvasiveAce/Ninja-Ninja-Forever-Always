extends Node2D

var enemyRandomizer := EnemyRandomizer.new()
var battlesWon := 0 
# Called when the node enters the scene tree for the first time.
func _ready():
	newBattle()

func battleResult(victor : Entity):
	if victor is Enemy:
		print("Game over!")
		print("You won " + str(battlesWon) + " battles!")
	else:
		if battlesWon < 99:
			victor.postBattleWinHeal()
			battlesWon += 1
			newBattle()
		else:
			print("You won the 100th battle! Come back for more next update.")

func newBattle():
	print("Battle " + "#" + str(battlesWon + 1))
	print("\n")
	var enemyToUse = enemyRandomizer.getRandomEnemy()
	add_child(enemyToUse)
	var battle = BattleSystem.new($Player, enemyToUse)
	battle.connect("battle_result", battleResult)
	add_child(battle)
	battle.startBattle()
