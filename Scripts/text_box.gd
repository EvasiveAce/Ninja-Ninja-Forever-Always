extends CanvasLayer

const CHAR_READ_RATE = .025

@onready var textbox_container = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label


##
# Credit to jontopielski on GitHub for this text box code and tutorial. 
##

var current_state = "State.READY"
var text_queue = []

func _ready():
	hide_textbox()


func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()


func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()


func display_text():
	var tween = get_tree().create_tween()
	var next_text = text_queue.pop_front()
	label.text = next_text
	change_state("State.READING")
	show_textbox()
	tween.tween_property(label, "visible_characters", len(next_text), (len(next_text) * CHAR_READ_RATE)).from(0)
	tween.connect("finished", on_tween_finished)

func on_tween_finished():
	end_symbol.text = "<-"
	change_state("State.FINISHED")


func change_state(next_state):
	current_state = next_state


func queue_text(next_text):
	text_queue.push_back(next_text)


func _process(_delta):
	match current_state:
		"State.READY":
			if !text_queue.is_empty():
				display_text()
		"State.READING":
			##TODO: Sound for each character
			# if label.visible_characters != -1:
			# 	print("noisehere")
			if Input.is_action_just_pressed("ui_accept"):
				#tween.kill()
				label.visible_characters = -1
				end_symbol.text = "<-"
				change_state("State.FINISHED")
		"State.FINISHED":
			if Input.is_action_just_pressed("ui_accept"):
				#tween.kill()
				label.visible_characters = -1
				end_symbol.text = "<-"
				change_state("State.READY")
				if text_queue.is_empty():
					hide_textbox()