extends Label

signal cursor_selected(nameToSignal : String)
signal cursor_broken(breakToSignal : String)

var itemPlaceholder = Item

func cursor_select() -> void:
	cursor_selected.emit(name)

func cursor_break() -> void:
	cursor_broken.emit("Break")