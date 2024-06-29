extends Button

@export var item : Item

# Called when the node enters the scene tree for the first time.
func _ready():
	$ItemLabel.text = item.itemName
	$ItemLabel/ItemDescription.text = item.itemDescription
	$ItemLabel/ItemCost.text = "¢%s" % item.itemPrice


