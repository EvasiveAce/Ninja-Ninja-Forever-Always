extends Control

signal rollButtonPressed
signal endTurnButtonPressed
signal itemButtonPressed(item : Item)


signal eitherButtonPressed

func _on_roll_button_pressed():
	rollButtonPressed.emit()
	eitherButtonPressed.emit()


func _on_end_turn_button_pressed():
	endTurnButtonPressed.emit()
	eitherButtonPressed.emit()


func _on_shop_container_item_button_pressed(item : Item):
	itemButtonPressed.emit(item)
	eitherButtonPressed.emit()
