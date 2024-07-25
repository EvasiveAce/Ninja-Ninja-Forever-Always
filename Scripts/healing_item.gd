class_name HealingItem

extends Item

@export var healAmount : int

func on_use(player : Entity):
    player.hp += healAmount
    return healAmount

func get_custom_class_name():
    return "HealingItem"