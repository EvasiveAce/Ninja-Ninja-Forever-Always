class_name BuffItem

extends Item

@export var buffAmount : int

@export var buffTurns : int

func on_use(player : Entity):
    player.buffAmount = buffAmount
    player.buffTurns = buffTurns
    return [buffAmount, buffTurns]

func get_custom_class_name():
    return "BuffItem"