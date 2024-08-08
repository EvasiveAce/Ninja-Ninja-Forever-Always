extends Control


signal itemButtonPressed(item : Item)

signal rollOption
signal endOption
signal eitherOption

signal textFinished

func _on_shop_container_item_button_pressed(item : Item):
	itemButtonPressed.emit(item)


func _on_menubox_option_chosen(extra_arg_0 : String):
	if extra_arg_0 == "Roll":
		rollOption.emit("Roll")
		eitherOption.emit()
	elif extra_arg_0 == "EndTurn":
		endOption.emit("EndTurn")
		eitherOption.emit()

func _on_textbox_text_finished():
	textFinished.emit()
