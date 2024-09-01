class_name CrownOfThorns

extends Item


func on_ready():
	$Sprite.visible = true

func get_custom_class_name():
	return "CrownOfThorns"


func on_add(_player : Entity):
	$Sprite.visible = false
	$PassiveSprite.visible = true

func start_animation():
	$PassiveSprite.stop()
	$PassiveSprite.play("Idle")