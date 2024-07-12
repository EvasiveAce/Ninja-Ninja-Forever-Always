class_name Player

extends Entity

@export var max_hp := 0
@export var money := 0
@export var xp := 0

@export var luck := 0

@export var rollAmount : int = 1

var hp : int:
	set(value):
		hp = clamp(value, 0, max_hp)
	get:
		return hp

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = max_hp
	inventory.add($Dice)

func postBattleWinHeal():
	var healthRoll = attackRoll()
	hp += healthRoll
	print(str(characterName) + " healed " + str(healthRoll) + "HP")
	print("\n")

func addMoney(moneyToAdd : int):
	print(str(characterName) + " received $" + str(moneyToAdd))
	money += moneyToAdd

func getPassives():
	pass

func getDice():
	return $Dice