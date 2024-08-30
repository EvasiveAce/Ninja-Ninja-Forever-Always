class_name DiceResource

extends Resource

@export var diceName : String:
	get:
		return "{0} D{1}".format([diceName, sides])

@export var sides : int
@export var modifier : int
