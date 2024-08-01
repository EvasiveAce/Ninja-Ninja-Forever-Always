extends Label

signal cursor_selected()

func cursor_select() -> void:
	emit_signal("cursor_selected")