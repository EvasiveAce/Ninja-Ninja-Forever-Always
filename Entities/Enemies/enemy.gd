class_name Enemy

extends Entity

@export var statSheet : StatSheet
@export var diceToGive : Dice

var hp : int:
	set(value):
		hp = clamp(value, 0, statSheet.max_hp)
	get:
		return hp


# Called when the node enters the scene tree for the first time.
func _ready():
	hp = statSheet.max_hp
	inventory.add($Dice)

func moneyDrop():
	var moneyToDrop = randi_range(0, statSheet.moneyRange)
	return moneyToDrop

func diceDrop():
	var percentage = statSheet.dropChance / 100.0
	if randi_range(1, 100) >= percentage:
		return diceToGive
