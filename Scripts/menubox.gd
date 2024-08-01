extends CanvasLayer

signal optionChosen



func _on_cursor_selected(extra_arg_0 : String):
	optionChosen.emit(extra_arg_0)
