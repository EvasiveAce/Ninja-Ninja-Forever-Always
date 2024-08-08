extends Control

@export var HPBarTheme: Theme
@export var RightLeft = 0

func _ready():
	$ProgressBar.theme = HPBarTheme
	if RightLeft == 0:
		$Label.position = Vector2(3,7)
	else:
		$ProgressBar.fill_mode = 1
		$Label.position = Vector2(106,7)


func update_bar(newValue : int):
	var tween = get_tree().create_tween()
	tween.tween_property($ProgressBar, "value", newValue, 1).from($ProgressBar.value)
	$ProgressBar.value = newValue
	

func set_max(newValue : int):
	$ProgressBar.max_value = newValue