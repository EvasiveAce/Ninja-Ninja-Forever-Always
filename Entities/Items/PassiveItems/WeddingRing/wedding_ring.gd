class_name WeddingRing

extends Item


func on_ready():
	$Sprite.visible = true

func get_custom_class_name():
	return "WeddingRing"

func on_add(player : Entity):
	$Sprite.visible = false
	$PassiveSprite.visible = true
	player.rollAmount += 1

func start_animation():
	$PassiveSprite.stop()
	$PassiveSprite.play("Idle")