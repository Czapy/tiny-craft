class_name GameManager
extends Node2D

@onready var main: Node2D = $"../Main"
@onready var land: TileMapLayer = $"../Main/Land"

var moved_item: GridItem
var moved_item_coords: Vector2i

func _ready():
	SignalBus.move.connect(_move)
	SignalBus.mine.connect(_mine)
	SignalBus.mining_finished.connect(_mining_finished)

func _process(_delta: float):
	handle_item_move()

func handle_item_move():
	if moved_item:
		var coords = land.local_to_map(land.to_local(get_global_mouse_position()))
		#moved_item.global_position = land.to_global(land.map_to_local(coords))
		#get_tree().create_tween().tween_property(item, "global_position", coords_to_global(coords), 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		get_tree().create_tween().tween_property(moved_item, "global_position", coords_to_global(coords), 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
		if can_swap_to(coords):
			moved_item.modulate = Color(1, 1, 1, 0.5)
		else:
			moved_item.modulate = Color(1, 0.2, 0.2, 0.5)

# Returns whether adding was successful
func add_to_grid(coords: Vector2i, scn: PackedScene, tween_from = null):
	if not can_place_to(coords):
		return false
	else:
		var item: GridItem = scn.instantiate()
		set_on_grid(coords, item, tween_from, 0.6)
		#item.global_position = coords_to_global(coords)
		main.add_child(item)
		return true

# Returns whether the item can be released at the given "to" coordinates
func move_on_grid(from: Vector2i, to: Vector2i, item: GridItem):
	if from == to:
		item.global_position = land.to_global(land.map_to_local(to))
		return true

	if not can_swap_to(to):
		return false
	elif not Globals.grid.has(to):
		Globals.grid.erase(from)
		set_on_grid(to, item)
	else:
		set_on_grid(from, Globals.grid[to], to)
		set_on_grid(to, item)
	SignalBus.grid_updated.emit()
	return true

func set_on_grid(coords: Vector2i, item: GridItem, tween_from = null, duration = 0.1):
	Globals.grid[coords] = item
	if tween_from != null:
		get_tree().create_tween()\
			.tween_property(item, "global_position", coords_to_global(coords), duration)\
			.from(coords_to_global(tween_from))\
			.set_ease(Tween.EASE_IN_OUT)\
			.set_trans(Tween.TRANS_CIRC)
	else:
		item.global_position = coords_to_global(coords)

func remove_from_grid(coords: Vector2i):
	var item: GridItem = Globals.grid.get(coords)
	if item:
		Globals.grid.erase(coords)
	return item

func coords_to_global(coords: Vector2i) -> Vector2:
	return land.to_global(land.map_to_local(coords))

func can_place_to(coords: Vector2i):
	return coords not in Globals.grid && land.get_cell_tile_data(coords)
	
func can_swap_to(coords: Vector2i):
	return land.get_cell_tile_data(coords)

#region Event handlers
func _move(coords: Vector2i):
	if not moved_item:
		if coords not in Globals.grid:
			return
		moved_item = Globals.grid[coords]
		moved_item.z_index = 1
		moved_item_coords = coords

func _mine(coords: Vector2i):
	if moved_item && move_on_grid(moved_item_coords, coords, moved_item):
		moved_item.modulate = Color(1, 1, 1, 1)
		moved_item.z_index = 0
		moved_item = null
	elif not moved_item && coords in Globals.grid && Globals.grid[coords].has_method("mine"):
		Globals.grid[coords].mine()

func _mining_finished(item: Farmable):
	var coords = Globals.grid.find_key(item)
	if coords == null:
		push_error("farmable not found in grid")
		return
	
	var cells_to_check = [
		coords + Vector2i.UP,
		coords + Vector2i.UP + Vector2i.RIGHT,
		coords + Vector2i.RIGHT,
		coords + Vector2i.RIGHT + Vector2i.DOWN,
		coords + Vector2i.DOWN,
		coords + Vector2i.DOWN + Vector2i.LEFT,
		coords + Vector2i.LEFT,
		coords + Vector2i.LEFT + Vector2i.UP
	]
	# find empty space
	for c in cells_to_check:
		if add_to_grid(c, item.drop, coords):
			SignalBus.grid_updated.emit()
			return
	# at this point spawning failed due to lack of space, not handled atm
	# TODO red progress bar that fades out?
	pass
#endregion
