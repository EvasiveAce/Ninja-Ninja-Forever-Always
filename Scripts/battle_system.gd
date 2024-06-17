class_name BattleSystem

extends Node2D

signal battle_result(victor)

@onready var player : Player
@onready var enemy : Enemy

func _init(playerParam : Player, enemyParam : Enemy):
	player = playerParam
	enemy = enemyParam

# Called when the node enters the scene tree for the first time.
func startBattle():
	print("Battle start!")
	print("Roll for speed!")
	print("\n")
	turnSystem(battleStart())

func battleStart():
	var speedRollVar = speedRoll()
	if speedRollVar[0] > speedRollVar[1]:
		print(player.characterName + " goes first!")
		print("\n")
		return player
	elif speedRollVar[0] < speedRollVar[1]:
		print(enemy.characterName + " goes first!")
		print("\n")
		return enemy
	else:
		print("Reroll!!")
		print("\n")
		battleStart()

func turnSystem(firstAttacker : Object):
	if firstAttacker == player:
		playerTurn()
	else:
		enemyTurn()

func playerTurn():
	getBattleHealth()
	var playerRoll = player.attackRoll()
	print(player.characterName + " rolled " + str(playerRoll) + " and hit!")
	playerHit(playerRoll)

func enemyTurn():
	getBattleHealth()
	var enemyRoll = enemy.attackRoll()
	print(enemy.characterName + " rolled " + str(enemyRoll) + " and hit!")
	enemyHit(enemyRoll)

func speedRoll():
	var playerSpeedRoll = player.attackRoll()
	var enemySpeedRoll = enemy.attackRoll()
	print(player.characterName + " rolled " + str(playerSpeedRoll))
	print(enemy.characterName + " rolled " + str(enemySpeedRoll))
	return [playerSpeedRoll, enemySpeedRoll]


func end(victor : Entity):
	battle_result.emit(victor)
	enemy.queue_free()
	queue_free()


func enemyHit(dmgToPlayer : int):
	player.hp -= dmgToPlayer
	if !player.hp:
		print(player.characterName + " has died!")
		end(enemy)
	else:
		playerTurn()

func playerHit(dmgToEnemy : int):
	enemy.hp -= dmgToEnemy
	if !enemy.hp:
		print(enemy.characterName + " has died!")
		player.addMoney(enemy.moneyDrop())
		player.inventory.add(enemy.diceDrop())
		end(player)
	else:
		enemyTurn()

func getBattleHealth():
	print(player.characterName + " Health: " + str(player.hp))
	print(enemy.characterName + " Health: " + str(enemy.hp))
	print("\n")
