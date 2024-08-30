extends TextureRect


@export var menu_parent_path : NodePath
@export var cursor_offset : Vector2

@onready var menu_parent := get_node(menu_parent_path)

var cursor_index : int = 0

func _process(_delta):
	var input := Vector2.ZERO

	if Input.is_action_just_pressed("ui_up"):
		input.y -= 1
	if Input.is_action_just_pressed("ui_down"):
		input.y += 1
	if Input.is_action_just_pressed("ui_left"):
		input.x -= 1
	if Input.is_action_just_pressed("ui_right"):
		input.x += 1

	if menu_parent is VBoxContainer:
		set_cursor_from_index(round(cursor_index + input.y))
	elif menu_parent is HBoxContainer:
		set_cursor_from_index(round(cursor_index + input.x))
	
	##TODO: ui select if needed here
	if Input.is_action_just_pressed("ui_accept") and get_parent().isActive:
		var current_menu_item := get_menu_item_at_index(cursor_index)
		if current_menu_item != null:
			if current_menu_item.has_method("cursor_select"):
				current_menu_item.cursor_select()
	elif Input.is_action_just_pressed("ui_text_backspace") and get_parent().isActive:
		var current_menu_item := get_menu_item_at_index(cursor_index)
		if current_menu_item != null:
			if current_menu_item.has_method("cursor_break"):
				current_menu_item.cursor_break()

func get_menu_item():
	return get_menu_item_at_index(cursor_index)


func get_menu_item_at_index(index : int) -> Control:
	if menu_parent == null:
		return null
	
	if index >= menu_parent.get_child_count() or index < 0:
		return null

	return menu_parent.get_child(index) as Control

func set_cursor_from_index(index : int) -> void:
	var menu_item := get_menu_item_at_index(index)
	if menu_item == null:
		return
	
	var positionToUse = menu_item.global_position
	var sizeToUse = menu_item.size

	global_position = Vector2(positionToUse.x, positionToUse.y + sizeToUse.y / 2.0) - (sizeToUse / 2.0) - cursor_offset

	cursor_index = index
