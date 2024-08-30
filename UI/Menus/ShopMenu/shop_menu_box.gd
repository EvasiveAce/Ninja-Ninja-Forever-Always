extends CanvasLayer

signal optionChosen

@onready var menubox_container = $ShopMenuContainer

var isActive := false

func _on_cursor_selected(extra_arg_0 : String):
	optionChosen.emit(extra_arg_0)
	print("Emitted")

func _on_cursor_broken(extra_arg_0 : String):
	optionChosen.emit(extra_arg_0)
	print("Emitted Broke")
	
func _ready():
	_hide_menu_box(false)

func _hide_menu_box(changeActive : bool):
	_change_activity(changeActive)
	hide()

func _show_menu_box(changeActive : bool):
	_change_activity(changeActive)
	show()

func _change_activity(activeState : bool) -> void:
	isActive = activeState



