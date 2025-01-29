extends TileMapLayer

func _input(event: InputEvent) -> void:
	var coords = local_to_map(get_local_mouse_position())
	
	if event.is_action_released("mine"):
		#var mouse_event: InputEventMouseButton = event
		SignalBus.mine.emit(coords)
	if event.is_action_pressed("move_item"):
		#var motion_event: InputEventMouseMotion = event
		SignalBus.move.emit(coords)
	pass
	#if event is InputEventMouseButton && event.is_pressed():
		#print(get_clicked_tile_power())
	#pass
	
func get_clicked_tile_power():
	var clicked_cell = local_to_map(get_local_mouse_position())
	var data = get_cell_tile_data(clicked_cell)
	return data

#func _process(delta: float) -> void:
	#if is_dragging:
		#global_position = tile_layer.to_global(tile_layer.map_to_local(tile_layer.local_to_map(tile_layer.to_local(get_global_mouse_position()))))
	#pass
#
#func _on_mouse_input(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if event.is_action_released("mine"):
		##var mouse_event: InputEventMouseButton = event
		##print(mouse_event)
		#print(tile_layer.local_to_map(tile_layer.to_local(global_position)))
	#if event.is_action_pressed("move_item"):
		##var motion_event: InputEventMouseMotion = event
		##print(motion_event)
		#is_dragging = not is_dragging
		#if is_dragging:
			#modulate.a = 0.5
		#else:
			#modulate.a = 1
	#pass
