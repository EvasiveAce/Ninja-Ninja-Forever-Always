class_name Dice

extends Node2D

@export var diceName : String:
	get:
		return "{0} D{1}".format([diceName, sides])

@export var sides : int
@export var modifier : int

var diceRoll : int:
	get:
		var rollNumber := randi_range(1, sides)
		if modifier:
			rollNumber = clamp(rollNumber + modifier, 1, rollNumber + modifier)
		return rollNumber

func roll():
	return diceRoll
