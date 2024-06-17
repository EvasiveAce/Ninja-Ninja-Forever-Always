class_name Enemy

extends Entity

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = max_hp
	inventory.add($Dice)

