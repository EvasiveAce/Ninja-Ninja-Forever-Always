class_name GameManager

extends Node

signal battleEnded(entity : Entity)

var battlesWon := 0 

@onready var textRows = $BattleUI/UI/MarginContainer2/TextRows

var mainLabel = preload("res://Scenes/main_label.tscn")
var playerLabel = preload("res://Scenes/roll_label.tscn")
var enemyLabel = preload("res://Scenes/enemy_roll_label.tscn")

var shopOption = preload("res://Scenes/shop_option.tscn")

@onready var battleSystem = $BattleSystem

var enemyRandomizer := EnemyRandomizer.new()
var healingItemRandomizer := HealingItemRandomizer.new()
var buffItemRandomizer := BuffItemRandomizer.new()
var passiveItemRandomizer := PassiveItemRandomizer.new()

var buttonPressed

func gameManagerInit(player : Entity = null):
	var enemyToUse = enemyRandomizer.getRandomEnemy()
	battleSystem.battleInit(player, enemyToUse)
	battleSystem.add_child(enemyToUse)

func _on_battle_ui_roll_button_pressed(buttonPressedS):
	buttonPressed = buttonPressedS
	print(buttonPressed)


func startBattlePhase():
	encounterBattlePhase()
	await $BattleUI.rollButtonPressed
	removeLabels()
	speedBattlePhase()



func encounterBattlePhase():
	$BattleUI/UI/MarginContainer/VBoxContainer/RollButton.text = "Battle!"
	addLabel("You encounter a %s" % battleSystem.enemy.characterName, mainLabel)

func speedBattlePhase():
	addLabel("Roll for speed!", mainLabel)
	$BattleUI/UI/MarginContainer/VBoxContainer/RollButton.text = "Roll"
	await $BattleUI.rollButtonPressed
	$BattleUI/UI/MarginContainer/VBoxContainer/RollButton.text = "Next"
	var speedRollVictor = battleSystem.speedRoll()
	addLabel("Ninja rolled a %s" % battleSystem.player.inventory.getDice().diceRoll, playerLabel)
	await $BattleUI.rollButtonPressed
	addLabel("%s rolled a %d" % [battleSystem.enemy.characterName, battleSystem.enemy.inventory.getDice().diceRoll], enemyLabel)
	await $BattleUI.rollButtonPressed
	addLabel("%s goes first!" % speedRollVictor.characterName, mainLabel)
	await $BattleUI.rollButtonPressed
	removeLabels()
	if speedRollVictor == battleSystem.player:
		playerTurnPhase()
	else:
		enemyTurnPhase()

func addLabel(text : String, typeOfLabel) -> void:
	if !text.is_empty():
		var newLabel = typeOfLabel.instantiate()
		newLabel.text = text
		textRows.add_child(newLabel)

func removeLabels() -> void:
	for child in textRows.get_children():
		child.queue_free()

func playerTurnPhase():
	var tempPlayerRollAmount = battleSystem.player.rollAmount
	var arrayOfRolls : Array[int] = []
	arrayOfRolls = await playerRollPhase(arrayOfRolls, tempPlayerRollAmount)
	$BattleUI/UI/MarginContainer/VBoxContainer/RollButton.text = "Next"
	removeLabels()
	addLabel("Attack Phase: Remaining rolls: %s" % (arrayOfRolls.size() - tempPlayerRollAmount), mainLabel)
	for dice in arrayOfRolls:
		addLabel("%s rolled a %d" % [battleSystem.player.characterName, dice], playerLabel)
	await $BattleUI.rollButtonPressed
	var damageToDeal = damageCalculation(arrayOfRolls, battleSystem.player)
	await $BattleUI.rollButtonPressed
	addLabel("%s's HP %s -> %s" % [battleSystem.enemy.characterName, battleSystem.enemy.hp, battleSystem.enemy.hp - damageToDeal], playerLabel)
	$BattleUI/UI/MarginContainer/VBoxContainer/RollButton.text = "Next"
	await $BattleUI.rollButtonPressed
	removeLabels()
	battleSystem.playerHit(damageToDeal)
	endTurnPhase(battleSystem.enemy)

func enemyTurnPhase():
	$BattleUI/UI/MarginContainer/VBoxContainer.visible = false
	var tempEnemyAmountRoll = battleSystem.enemy.statSheet.rollAmount
	print(tempEnemyAmountRoll)
	var arrayOfRolls : Array[int] = []
	for i in tempEnemyAmountRoll:
		arrayOfRolls.append(battleSystem.enemy.inventory.getDice().roll())
		var tempDamage = 0
		for roll in arrayOfRolls:
			tempDamage += roll
		if tempDamage >= battleSystem.player.hp:
			break
		if arrayOfRolls.size() >= 2:
			var crit = true
			var baseRoll = arrayOfRolls[i]
			for roll in arrayOfRolls:
				if roll != baseRoll:
					crit = false
			if crit == true:
				break
	$BattleUI/UI/MarginContainer/VBoxContainer/RollButton.text = "Next"
	removeLabels()
	addLabel("Attack Phase: Remaining rolls: %s" % (tempEnemyAmountRoll - arrayOfRolls.size()), mainLabel)
	for dice in arrayOfRolls:
		$Timer.start()
		addLabel("%s rolled a %d" % [battleSystem.enemy.characterName, dice], enemyLabel)
		await $Timer.timeout
	var damageToDeal = damageCalculation(arrayOfRolls, battleSystem.enemy)
	await $Timer.timeout
	addLabel("%s's HP %s -> %s" % [battleSystem.player.characterName, battleSystem.player.hp, battleSystem.player.hp - damageToDeal], enemyLabel)
	$BattleUI/UI/MarginContainer/VBoxContainer.visible = true
	$BattleUI/UI/MarginContainer/VBoxContainer/RollButton.text = "Next"
	await $BattleUI.rollButtonPressed
	removeLabels()
	battleSystem.enemyHit(damageToDeal)
	endTurnPhase(battleSystem.player)

func playerRollPhase(arrayOfRolls : Array[int], tempAmount : int) -> Array[int]:
	##TODO: program luck here for more crits - if you have more than 1 roll, it will be more likely to be the same
	while tempAmount > 0:
		$BattleUI/UI/MarginContainer/VBoxContainer/RollButton.text = "Roll"
		await $BattleUI.eitherButtonPressed
		removeLabels()
		battleSystem.player.inventory.getDice().roll()
		if !arrayOfRolls.is_empty():
			addLabel("Attack Phase: Remaining rolls: %s" % tempAmount, mainLabel)
			for dice in arrayOfRolls:
				addLabel("%s rolled a %d" % [battleSystem.player.characterName, dice], playerLabel)
		else:
			addLabel("Attack Phase: Remaining rolls: %s" % tempAmount, mainLabel)
		await $BattleUI.eitherButtonPressed
		if buttonPressed == "rollButton":
			tempAmount -= 1
			addLabel("%s rolled a %d" % [battleSystem.player.characterName, battleSystem.player.inventory.getDice().diceRoll], playerLabel)
			arrayOfRolls.append(battleSystem.player.inventory.getDice().diceRoll)
		elif buttonPressed == "endButton":
			break
	return arrayOfRolls

func endTurnPhase(deathCheckEntity : Entity):
	if !deathCheckEntity.hp:
		endBattlePhase()
	else:
		if deathCheckEntity == battleSystem.player:
			playerTurnPhase()
		else:
			enemyTurnPhase()

func endBattlePhase():
	if !battleSystem.player.hp:
		addLabel("%s has died!" % battleSystem.player.characterName, mainLabel)
	else:
		$BattleUI/UI/MarginContainer/VBoxContainer.visible = false
		$Timer.start()
		addLabel("%s has died!" % battleSystem.enemy.characterName, mainLabel)
		await $Timer.timeout
		var moneyDrop = battleSystem.enemy.moneyDrop()
		if moneyDrop > 0:
			$Timer.start()
			addLabel("%s dropped %s gold!" % [battleSystem.enemy.characterName, moneyDrop], mainLabel)
			await $Timer.timeout
			battleSystem.player.addMoney(moneyDrop)
			$Timer.start()
			addLabel("Amount of Gold: %s -> %s" % [(battleSystem.player.money - moneyDrop), battleSystem.player.money], mainLabel)
			await $Timer.timeout
		$BattleUI/UI/MarginContainer/VBoxContainer.visible = true
		await $BattleUI.eitherButtonPressed
		battleEnded.emit(battleSystem.player)
	# 	player.inventory.add(enemy.diceDrop())

func checkForCrit(arrayOfDice : Array[int]):
	var willCrit := false
	if arrayOfDice.size() >= 2:
		willCrit = true
		var tempSide := arrayOfDice[0]
		for dice in arrayOfDice:
			if dice != tempSide:
				willCrit = false
	return willCrit

func damageCalculation(arrayOfDice : Array[int], entity : Entity) -> int:
	var willCrit = checkForCrit(arrayOfDice)
	var damageToDeal := 0
	for dice in arrayOfDice:
		damageToDeal += dice
	if willCrit:
		if entity == battleSystem.player:
			addLabel("CRITICAL HIT!!", playerLabel)
		else:
			addLabel("CRITICAL HIT!!", enemyLabel)
		damageToDeal *= arrayOfDice.size()
	if entity == battleSystem.player:
		addLabel("%s dealt %s" % [entity.characterName, damageToDeal], playerLabel)
	else:
		addLabel("%s dealt %s" % [entity.characterName, damageToDeal], enemyLabel)
	return damageToDeal

# func _on_battle_system_battle_result(victor : Entity):
# 	if victor is Enemy:
# 		print("Game over!")
# 		print("You won " + str(battlesWon) + " battles!")
# 	else:
# 		if battlesWon < 99:
# 			victor.postBattleWinHeal()
# 			battlesWon += 1
# 			battleInit(victor)
# 			startBattlePhase()
# 		else:
# 			print("You won the 100th battle! Come back for more next update.")


func healRoll(entity : Entity):
	addLabel("Roll for healing", mainLabel)
	await $BattleUI.rollButtonPressed
	var healRollVar = entity.inventory.getDice().roll()
	addLabel("%s healed for %s" % [entity.characterName, healRollVar], mainLabel)
	addLabel("HP %s -> %s" % [entity.hp, entity.hp + healRollVar], mainLabel)
	entity.hp += healRollVar
	await $BattleUI.rollButtonPressed


func shop(entity : Entity):
	var maxItems := 3
	$BattleUI/UI/MarginContainer/VBoxContainer/RollButton.visible = false
	$BattleUI/UI/MarginContainer/ShopContainer.visible = true
	for i in maxItems:
		var newShopOption = shopOption.instantiate()
		var newItem : Item
		match maxItems:
			3:
				newItem = healingItemRandomizer.getRandomHealing()
			2:
				newItem = passiveItemRandomizer.getRandomPassive()
			1:
				newItem = buffItemRandomizer.getRandomBuff()
		newShopOption.add_child(newItem)
		newShopOption.item = newItem
		$BattleUI/UI/MarginContainer/ShopContainer.add_child(newShopOption)
		maxItems -= 1
	##TODO: Make percentages of drop/itemchances
	await $BattleUI.eitherButtonPressed
	if buttonPressed is String:
		$BattleUI/UI/MarginContainer/VBoxContainer/RollButton.visible = true
		$BattleUI/UI/MarginContainer/ShopContainer.visible = false
	else:
		pass

	



func _on_battle_ui_either_button_pressed():
	pass # Replace with function body.


func _on_timer_timeout():
	pass # Replace with function body.
