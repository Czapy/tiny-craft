extends TileMapLayer

func _input(event: InputEvent) -> void:
	var coords = local_to_map(get_local_mouse_position())
	if event.is_action_released("mine"):
		SignalBus.mine.emit(coords)
	if event.is_action_pressed("move_item"):
		SignalBus.move.emit(coords)
