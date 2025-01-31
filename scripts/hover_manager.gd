extends Node2D

# TODO show hovered item name

func _ready():
	SignalBus.clickable_hovered.connect(_on_clickable_entered)
	SignalBus.clickable_exited.connect(_on_clickable_exited)
	
func _on_clickable_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	
func _on_clickable_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
