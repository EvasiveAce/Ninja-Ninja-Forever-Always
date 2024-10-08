class_name GameManager

extends Node

signal battleEnded(entity : Entity)

var battlesWon := 0 


############ Signal Variables

@onready var rollOption = $BattleUI.rollOption
@onready var endOption = $BattleUI.endOption
@onready var eitherOption = $BattleUI.eitherOption

@onready var item1Option = $BattleUI.item1
@onready var item2Option = $BattleUI.item2
@onready var item3Option = $BattleUI.item3
@onready var itemOption = $BattleUI.itemOption

@onready var textFinished = $BattleUI.textFinished

var optionChosen

#####################

############ BattleSystem Variables

@onready var battleSystem = $BattleSystem
var player
var enemy

#####################

############ Text Variables

@onready var textBox = $BattleUI/Textbox
@onready var menuBox = $BattleUI/Menubox
@onready var shopBox = $BattleUI/ShopMenuBox

#####################

############ HealthBar Variables

@onready var playerHPBar = $BattleUI/PlayerHPBar
@onready var enemyHPBar = $BattleUI/EnemyHPBar

#####################

############ Shop Variables

@onready var item1 = $BattleUI/ShopMenuBox/ShopMenuContainer/MarginContainer/HBoxContainer/Item1
@onready var item1Cost = $BattleUI/ShopMenuBox/ShopMenuContainer/MarginContainer/HBoxContainer/Item1/Item1Cost

@onready var item2 = $BattleUI/ShopMenuBox/ShopMenuContainer/MarginContainer/HBoxContainer/Item2
@onready var item2Cost = $BattleUI/ShopMenuBox/ShopMenuContainer/MarginContainer/HBoxContainer/Item2/Item2Cost

@onready var item3 = $BattleUI/ShopMenuBox/ShopMenuContainer/MarginContainer/HBoxContainer/Item3
@onready var item3Cost = $BattleUI/ShopMenuBox/ShopMenuContainer/MarginContainer/HBoxContainer/Item3/Item3Cost

#####################

var enemyRandomizer := EnemyRandomizer.new()
var healingItemRandomizer := HealingItemRandomizer.new()
var buffItemRandomizer := BuffItemRandomizer.new()
var passiveItemRandomizer := PassiveItemRandomizer.new()

func gameManagerInit(playerInit : Entity = null, isBoss : bool = false):
	var enemyToUse
	if !isBoss:
		enemyToUse = enemyRandomizer.getRandomEnemy()
	else:
		enemyToUse = enemyRandomizer.getBossEnemy()
	battleSystem.battleInit(playerInit, enemyToUse)
	battleSystem.add_child(enemyToUse)
	player = $BattleSystem.player
	enemy = $BattleSystem.enemy
	
func _on_option(extra_arg_0 : String):
	optionChosen = extra_arg_0

func startBattlePhase():
	enemyHPBar.set_max(enemy.hp)
	enemyHPBar.update_bar(enemy.hp)
	encounterBattlePhase()
	#removeLabels()
	speedBattlePhase()

func encounterBattlePhase():
	#$BattleUI/UI/MarginContainer/VBoxContainer/RollButton.text = "Battle!"
	textBox.queue_text("You encounter a %s" % enemy.characterName)


func speedBattlePhase():
	textBox.queue_text("Roll for speed!")
	await textFinished
	menuBox._show_menu_box(true)
	await rollOption
	menuBox._hide_menu_box(false)
	var speedRollVictor = battleSystem.speedRoll()
	textBox.queue_text("%s rolled a %s" % [player.name, player.inventory.getDice().diceRoll])
	textBox.queue_text("%s rolled a %s" % [enemy.characterName, enemy.inventory.getDice().diceRoll])
	textBox.queue_text("%s goes first!" % speedRollVictor.characterName)
	await textFinished	
	if speedRollVictor == battleSystem.player:
		playerTurnPhase()
	else:
		enemyTurnPhase()


# func addLabel(text : String, typeOfLabel) -> void:
# 	if !text.is_empty():
# 		if typeOfLabel == playerLabel:
# 			var newLabel = typeOfLabel.instantiate()
# 			newLabel.text = text
# 			playerTextRows.add_child(newLabel)
# 		else:
# 			var newLabel = typeOfLabel.instantiate()
# 			newLabel.text = text
# 			textRows.add_child(newLabel)

# func removeLabels() -> void:
# 	for child in textRows.get_children():
# 		child.queue_free()
# 	for child in playerTextRows.get_children():
# 		child.queue_free()

func buffCheck():
	if player.buffTurns > 0:
		player.buffTurns -= 1
		return player.buffAmount
	else:
		return 0

func playerTurnPhase():
	var tempPlayerRollAmount = player.rollAmount
	var arrayOfRolls : Array[int] = []
	arrayOfRolls = await playerRollPhase(arrayOfRolls, tempPlayerRollAmount, buffCheck())
	#$BattleUI/UI/MarginContainer/VBoxContainer/RollButton.text = "Next"
	#textBox.queue_text("Attack Phase: Remaining rolls: %s" % (arrayOfRolls.size() - tempPlayerRollAmount))
	var tempDisplay = " "
	var tempSize = arrayOfRolls.size()
	for dice in arrayOfRolls:
		tempSize -= 1
		if tempSize != 0:
			tempDisplay += "%s + " % dice
		else:
			tempDisplay += "%s = %s" % [dice, damageCalculation(arrayOfRolls, player)] 
	textBox.queue_text(tempDisplay)
	var damageToDeal = damageCalculation(arrayOfRolls, player)
	#addLabel("%s's HP %s -> %s" % [battleSystem.enemy.characterName, battleSystem.enemy.hp, battleSystem.enemy.hp - damageToDeal], playerLabel)
	enemyHPBar.update_bar(enemy.hp - damageToDeal)
	#$BattleUI/UI/MarginContainer/VBoxContainer/RollButton.text = "Next"
	await textFinished
	battleSystem.playerHit(damageToDeal)
	endTurnPhase(enemy)

func enemyTurnPhase():
	var tempEnemyAmountRoll = enemy.statSheet.rollAmount
	var arrayOfRolls : Array[int] = []
	for i in tempEnemyAmountRoll:
		arrayOfRolls.append(enemy.inventory.getDice().roll())
		var tempDamage = 0
		for roll in arrayOfRolls:
			tempDamage += roll
		if tempDamage >= player.hp:
			break
		if arrayOfRolls.size() >= 2:
			var crit = true
			var baseRoll = arrayOfRolls[i]
			for roll in arrayOfRolls:
				if roll != baseRoll:
					crit = false
			if crit == true:
				break
	textBox.queue_text("Enemy Remaining rolls: %s" % (tempEnemyAmountRoll - arrayOfRolls.size()))
	await textFinished
	for dice in arrayOfRolls:
		textBox.queue_text("%s rolled a %d" % [enemy.characterName, dice])
	var damageToDeal = damageCalculation(arrayOfRolls, enemy)
	textBox.queue_text("%s's HP %s -> %s" % [player.characterName, player.hp, player.hp - damageToDeal])
	await textFinished
	playerHPBar.update_bar(player.hp - damageToDeal)
	#$BattleUI/UI/MarginContainer/VBoxContainer/RollButton.text = "Next"
	await textFinished
	battleSystem.enemyHit(damageToDeal)
	endTurnPhase(player)


func playerRollPhase(arrayOfRolls : Array[int], tempAmount : int, buffAmount : int) -> Array[int]:
	##TODO: program luck here for more crits - if you have more than 1 roll, it will be more likely to be the same
		#$BattleUI/UI/MarginContainer/VBoxContainer/RollButton.text = "Roll"
		#await eitherOption
		# if !arrayOfRolls.is_empty():
		# 	textBox.queue_text("Attack Phase: Remaining rolls: %s %" % tempAmount)
		# 	# for dice in arrayOfRolls:
		# 	# 	textBox.queue_text("%d" % dice)
		# else:
		# 	textBox.queue_text("Attack Phase: Remaining rolls: %s" % tempAmount)
	while tempAmount > 0:
		player.inventory.getDice().roll()
		menuBox._show_menu_box(true)
		textBox.queue_text("Attack Phase: Remaining rolls: %s" % tempAmount)
		await eitherOption
		if optionChosen == "Roll":
			menuBox._hide_menu_box(false)
			tempAmount -= 1
				#TODO: If I want to do +4 in the text, its here.
			var tempRoll = player.inventory.getDice().diceRoll
			if buffAmount > 0:
				tempRoll += buffAmount
			textBox.queue_text("Rolled a %d" % tempRoll)
			arrayOfRolls.append(tempRoll)
			await textFinished
		elif optionChosen == "EndTurn":
			menuBox._hide_menu_box(false)
			return arrayOfRolls
		#if tempAmount > 0:
			#return await playerRollPhase(arrayOfRolls, tempAmount, buffAmount)
		#menuBox._hide_menu_box(false)
	menuBox._hide_menu_box(false)
	return arrayOfRolls

func endTurnPhase(deathCheckEntity : Entity):
	if !deathCheckEntity.hp:
		endBattlePhase()
	else:
		if deathCheckEntity == player:
			playerTurnPhase()
		else:
			enemyTurnPhase()

func endBattlePhase():
	if !player.hp:
		textBox.queue_text("%s has died!" % player.characterName)
	else:
		enemy.queue_free()
		#$Timer.start()
		textBox.queue_text("%s has died!" % enemy.characterName)
		#await $Timer.timeout
		var moneyDrop = enemy.moneyDrop()
		if moneyDrop > 0:
			#$Timer.start()
			textBox.queue_text("%s dropped %s gold!" % [enemy.characterName, moneyDrop])
			#await $Timer.timeout
			player.addMoney(moneyDrop)
			#$Timer.start()
			textBox.queue_text("Amount of Gold: %s -> %s" % [(player.money - moneyDrop), player.money])
			#await $Timer.timeout
		await textFinished
		battleEnded.emit(player)
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
		if entity == player:
			textBox.queue_text("CRITICAL HIT!!")
		else:
			textBox.queue_text("CRITICAL HIT!!")
		damageToDeal *= arrayOfDice.size()
	var playerPassiveCheck = player.getPassives()
	for passive in playerPassiveCheck:
		if passive.get_custom_class_name() == "CrownOfThorns" and entity == enemy:
			textBox.queue_text("The crown sinks into your skin")
			damageToDeal += 1
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
	textBox.queue_text("Roll for healing")
	menuBox._show_menu_box(true)
	await rollOption
	menuBox._hide_menu_box(false)
	var healRollVar = entity.inventory.getDice().roll()
	var playerPassiveCheck = player.getPassives()
	for passive in playerPassiveCheck:
		if passive.get_custom_class_name() == "CrownOfThorns":
			textBox.queue_text("You feel holy")
			healRollVar *= 2
	textBox.queue_text("%s healed for %s" % [entity.characterName, healRollVar])
	#addLabel("HP %s -> %s" % [entity.hp, entity.hp + healRollVar], mainLabel) 
	#TODO: Add HP Bar interaction
	#TODO: Clamp
	playerHPBar.update_bar(entity.hp + healRollVar)
	entity.hp += healRollVar
	await textFinished


func shop(entity : Entity):
	var maxItems := 3
	#$BattleUI/UI/MarginContainer/VBoxContainer/RollButton.visible = false
	#$BattleUI/UI/MarginContainer/ShopContainer.visible = true
	for i in maxItems:
		var newItem : Item
		match maxItems:
			3:
				newItem = healingItemRandomizer.getRandomHealing()
				item3.add_child(newItem)
				item3.itemPlaceholder = newItem
				item3.set_text(newItem.itemName)
				item3Cost.set_text("$%s" % newItem.itemPrice)
			2:
				newItem = passiveItemRandomizer.getRandomPassive()
				item2.add_child(newItem)
				item2.itemPlaceholder = newItem
				item2.set_text(newItem.itemName)
				item2Cost.set_text("$%s" % newItem.itemPrice)
			1:
				newItem = buffItemRandomizer.getRandomBuff()
				item1.add_child(newItem)
				item1.itemPlaceholder = newItem
				item1.set_text(newItem.itemName)
				item1Cost.set_text("$%s" % newItem.itemPrice)
		maxItems -= 1

	textBox.queue_text("You found a shop!")
	##TODO: Make percentages of drop/itemchances
	await shop_purchase_attempt(entity)
#	for child in $BattleUI/UI/MarginContainer/ShopContainer.get_children():
#		child.queue_free()

	
func shop_purchase_attempt(entity : Entity):
	var tempVar = false
	while !tempVar:
		menuBox._show_menu_box(true)
		await textFinished
		if optionChosen == "Roll":
			menuBox._show_menu_box(false)
			shopBox._show_menu_box(true)
			await itemOption
			if optionChosen == "Item1":
				tempVar = await shopChoice(item1, entity)
			elif optionChosen == "Item2":
				tempVar = await shopChoice(item2, entity)
			elif optionChosen == "Item3":
				tempVar = await shopChoice(item3, entity)
			elif optionChosen == "Break":
				shopBox._hide_menu_box(false)
		elif optionChosen == "EndTurn":
				menuBox._hide_menu_box(false)
				return


func shopChoice(optionPreItem : Label, entity : Entity):
	var optionChose = optionPreItem.itemPlaceholder
	if entity.money >= optionChose.itemPrice:
		menuBox._hide_menu_box(false)
		shopBox._hide_menu_box(false)
		entity.money -= optionChose.itemPrice
		match optionChose.get_custom_class_name():
			"HealingItem":
				var amountHealed = entity.useHealing(optionPreItem.get_child(1))
				playerHPBar.update_bar(entity.hp)
				#$BattleUI/UI/MarginContainer/ShopContainer.visible = false
				textBox.queue_text("%s bought %s for %s" % [entity.characterName, optionChose.itemName, optionChose.itemPrice])
				textBox.queue_text("%s healed for %s" % [entity.characterName, amountHealed])
				await textFinished
				optionPreItem.get_child(1).queue_free()
				optionChose = null

			"BuffItem":
				var buffAmountAndTurns = entity.useBuff(optionPreItem.get_child(1))
				#$BattleUI/UI/MarginContainer/ShopContainer.visible = false
				textBox.queue_text("%s bought %s for %s" % [entity.characterName, optionChose.itemName, optionChose.itemPrice])
				textBox.queue_text("%s's dice is +%s for %s turns" % [entity.characterName, buffAmountAndTurns[0], buffAmountAndTurns[1]])
				await textFinished
				optionPreItem.get_child(1).queue_free()
				optionChose = null
			_:
				entity.addPassive(optionPreItem.get_child(1))
				#$BattleUI/UI/MarginContainer/ShopContainer.visible = false
				textBox.queue_text("%s bought %s for %s" % [entity.characterName, optionChose.itemName, optionChose.itemPrice])
				await textFinished
				optionChose = null
		return true
	return false

func item_drop(entity : Entity):
	#var maxItems := 1
	#$BattleUI/UI/MarginContainer/VBoxContainer/RollButton.visible = false
	$BattleUI/ItemPedestal.visible = true
	#for i in maxItems:
		#var newShopOption = shopOption.instantiate()
		#var newItem : Item
		#newItem = passiveItemRandomizer.getRandomPassive()
		#$BattleUI/ItemPedestal.add_child(newItem)
		#newItem.itemPrice = 0
		#newShopOption.item = newItem
		#newShopOption.get_child(0).get_child(1).visible = false
		# Get the cost label and hide it 
		#$BattleUI/UI/MarginContainer/ShopContainer.add_child(newShopOption)
		#maxItems -= 1
	var newItem : Item
	newItem = passiveItemRandomizer.getRandomPassive()
	$BattleUI/ItemPedestal.add_child(newItem)
	newItem.on_ready()
	##TODO: Make percentages of drop/itemchances
	await item_accept(entity, newItem)
#	for child in $BattleUI/UI/MarginContainer/ShopContainer.get_children():
#		child.queue_free()
	$BattleUI/ItemPedestal.visible = false


func item_accept(entity : Entity, newItem : Item):
	textBox.queue_text("You found a %s!" % newItem.name)
	await textFinished
	menuBox._show_menu_box(true)
	await eitherOption
	menuBox._hide_menu_box(false)
	if optionChosen != "Roll":
		#$BattleUI/UI/MarginContainer/VBoxContainer/RollButton.visible = true
		#$BattleUI/UI/MarginContainer/ShopContainer.visible = false
		return
	else:
		entity.addPassive(newItem)
		#$BattleUI/UI/MarginContainer/ShopContainer.visible = false
		textBox.queue_text("%s picked up %s!!" % [entity.characterName, newItem.name])
		#$BattleUI/UI/MarginContainer/VBoxContainer/RollButton.visible = true
		await textFinished

func _on_battle_ui_either_button_pressed():
	pass # Replace with function body.


func _on_timer_timeout():
	pass # Replace with function body.

func _on_battle_ui_text_finished():
	pass # Replace with function body.
