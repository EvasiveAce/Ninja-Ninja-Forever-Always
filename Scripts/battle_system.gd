class_name BattleSystem

extends Node2D

signal battle_result(victor)


@onready var player : Player
@onready var enemy : Enemy

func battleInit(playerParam : Player, enemyParam : Enemy):
	player = playerParam
	enemy = enemyParam

# Called when the node enters the scene tree for the first time.
func startBattle():
	print("Battle start!")
	print("Roll for speed!")
	print("\n")

func speedRoll():
	var speedRollVar = [player.attackRoll(), enemy.attackRoll()]
	if speedRollVar[0] > speedRollVar[1]:
		return player
	elif speedRollVar[0] < speedRollVar[1]:
		return enemy
	else:
		return speedRoll()

func turnSystem(firstAttacker : Object):
	if firstAttacker == player:
		return firstAttacker
	else:
		return firstAttacker

func end(victor : Entity):
	battle_result.emit(victor)

func enemyHit(dmgToPlayer : int):
	player.hp -= dmgToPlayer
	# if !player.hp:
	# 	print(player.characterName + " has died!")
	# 	end(enemy)

func playerHit(dmgToEnemy : int):
	enemy.hp -= dmgToEnemy
	# if !enemy.hp:
	# 	print(enemy.characterName + " has died!")
	# 	player.addMoney(enemy.moneyDrop())
	# 	player.inventory.add(enemy.diceDrop())
	# 	end(player)

func getBattleHealth():
	print(player.characterName + " Health: " + str(player.hp))
	print(enemy.characterName + " Health: " + str(enemy.hp))
	print("\n")

