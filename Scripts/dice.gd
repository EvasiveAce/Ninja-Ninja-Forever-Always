class_name Dice

extends Node2D

@export var diceResource : DiceResource
@onready var sides := diceResource.sides
@onready var modifier := diceResource.modifier

var diceRoll : int:
	get:
		var rollNumber := randi_range(1, sides)
		if modifier:
			rollNumber = clamp(rollNumber + modifier, 1, rollNumber + modifier)
		return rollNumber

func roll():
	return diceRoll
