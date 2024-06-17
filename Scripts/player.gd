class_name Player

extends Entity

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = max_hp
	inventory.add($NinjaDice)

func postBattleWinHeal():
	var healthRoll = attackRoll()
	hp += healthRoll
	print(str(characterName) + " healed " + str(healthRoll) + "HP")
	print("\n")
