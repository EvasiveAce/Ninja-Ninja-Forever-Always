extends Label

signal cursor_selected(nameToSignal : String)

func cursor_select() -> void:
	cursor_selected.emit(name)