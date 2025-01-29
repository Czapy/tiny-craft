class_name GameManager
extends Node2D

@export var grid = {}

@onready var main: Node2D = $"../Main"
@onready var land: TileMapLayer = $"../Main/Land"

var moved_item: GridItem
var moved_item_coords: Vector2i

func _ready():
	SignalBus.move.connect(_move)
	SignalBus.mine.connect(_mine)
	
func _process(delta: float):
	if moved_item:
		var coords = land.local_to_map(land.to_local(get_global_mouse_position()))
		moved_item.global_position = land.to_global(land.map_to_local(coords))
		if not land.get_cell_tile_data(coords) or (coords in grid and coords != moved_item_coords):
			moved_item.modulate = Color(1, 0.2, 0.2, 0.5)
		else:
			moved_item.modulate = Color(1, 1, 1, 0.5)

func _move(coords: Vector2i):
	if not moved_item:
		if not grid.has(coords):
			return
		moved_item = grid[coords]
		moved_item.z_index = 1
		moved_item_coords = coords

func _mine(coords: Vector2i):
	if moved_item && moveOnGrid(moved_item_coords, coords, moved_item):
		moved_item.modulate = Color(1, 1, 1, 1)
		moved_item.z_index = 0
		moved_item = null
	elif not moved_item && grid.has(coords) && grid[coords].has_method("mine"):
		grid[coords].mine()

#region Grid Management
func addToGrid(coords: Vector2i, scn: PackedScene):
	if coords in grid:
		return false
	else:
		var item: GridItem = scn.instantiate()
		grid[coords] = item
		item.global_position = land.to_global(land.map_to_local(coords))
		main.add_child(item)
		return true

func moveOnGrid(from: Vector2i, to: Vector2i, item: GridItem):
	if from == to:
		item.global_position = land.to_global(land.map_to_local(to))
		return true

	if to in grid or not land.get_cell_tile_data(to):
		return false
	else:
		grid.erase(from)
		grid[to] = item
		item.global_position = land.to_global(land.map_to_local(to))
		return true
#endregion

func _on_clickable_entered():
	print("_on_clickable_entered")
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	
func _on_clickable_exited():
	print("_on_clickable_exited")
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
