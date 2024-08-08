class_name RabbitsFoot

extends Item

func _ready():
	$Sprite.visible = true

func get_custom_class_name():
	return "RabbitsFoot"


func on_add(player : Entity):
	$Sprite.visible = false
	$PassiveSprite.visible = true
	player.luck += 1
