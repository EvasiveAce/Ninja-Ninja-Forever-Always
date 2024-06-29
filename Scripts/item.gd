class_name Item

extends Node2D

@export var itemResource : ItemResource


var itemName : String
var itemDescription : String
var itemPrice : int

func _ready():
	itemName = itemResource.itemName
	itemDescription = itemResource.itemDescription
	itemPrice = itemResource.itemPrice
