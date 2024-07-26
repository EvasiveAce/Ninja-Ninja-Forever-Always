class_name RabbitsFoot

extends Item

func get_custom_class_name():
	return "RabbitsFoot"


func on_add(player : Entity):
	player.luck += 1
