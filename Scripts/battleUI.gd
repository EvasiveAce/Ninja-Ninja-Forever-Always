extends Control


signal rollOption
signal endOption
signal eitherOption

signal item1
signal item2
signal item3
signal itemOption

signal textFinished


func _on_menubox_option_chosen(extra_arg_0 : String):
	if extra_arg_0 == "Roll":
		rollOption.emit("Roll")
		eitherOption.emit()
	elif extra_arg_0 == "EndTurn":
		endOption.emit("EndTurn")
		eitherOption.emit()


func _on_textbox_text_finished():
	textFinished.emit()


func _on_shop_menu_box_option_chosen(extra_arg_0 : String):
	if extra_arg_0 == "Item1":
		item1.emit("Item1")
		itemOption.emit()
	elif extra_arg_0 == "Item2":
		item2.emit("Item2")
		itemOption.emit()
	elif extra_arg_0 == "Item3":
		item3.emit("Item3")
		itemOption.emit()
	elif extra_arg_0 == "Break":
		item1.emit("Break")
		itemOption.emit()
