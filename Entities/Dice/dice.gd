class_name Dice

extends Node2D

@export var diceResource : DiceResource
@onready var sides := diceResource.sides
@onready var modifier := diceResource.modifier

@onready var diceRoll : int

func roll():
	diceRoll = randi_range(1, sides)
	if modifier:
		diceRoll = clamp(diceRoll + modifier, 1, sides + modifier)
	return diceRoll
