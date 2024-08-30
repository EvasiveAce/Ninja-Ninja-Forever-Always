class_name RabbitsFoot

extends Item


func on_ready():
	$Sprite.visible = true

func get_custom_class_name():
	return "RabbitsFoot"


func on_add(player : Entity):
	$Sprite.visible = false
	$PassiveSprite.visible = true
	player.luck += 1

func start_animation():
	$PassiveSprite.stop()
	$PassiveSprite.play("Idle")