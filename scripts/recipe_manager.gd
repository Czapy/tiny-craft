class_name RecipeManager
extends Node2D

@export var recipes: Dictionary = {
	GridItem.ItemType.STICK: {
		Vector2i(0, 0): GridItem.ItemType.WOOD,
		Vector2i(0, 1): GridItem.ItemType.WOOD
	},
	GridItem.ItemType.AXE: {
		Vector2i(0, 0): GridItem.ItemType.STONE,
		Vector2i(-1, 0): GridItem.ItemType.STONE,
		Vector2i(-1, 1): GridItem.ItemType.STONE,
		Vector2i(0, 1): GridItem.ItemType.STICK,
		Vector2i(0, 2): GridItem.ItemType.STICK
	}
}

# [[<recipe part coords>: Vector2i], PackedScene]
@export var valid_recipes = []

@onready var item_list: ItemList = %ItemList

func _ready():
	SignalBus.grid_updated.connect(_grid_updated)
	item_list.connect("item_selected", _craft_item)

func update_ui():
	item_list.clear()
	for recipe in valid_recipes:
		var scn: PackedScene = recipe[1]
		var state: GridItem = scn.instantiate()
		var idx = item_list.add_item(state.label)
		state.queue_free()
		item_list.set_item_metadata(idx, recipe)

func _craft_item(index: int):
	var item = item_list.get_item_metadata(index)
	var parts: Array = item[0]
	var scene: PackedScene = item[1]
	var root_coords = parts[0]
	
	for part_coords in parts:
		var removed_item = Globals.game_manager.remove_from_grid(part_coords)
		if removed_item:
			var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
			tween.tween_property(removed_item, "global_position", Globals.game_manager.coords_to_global(root_coords), 0.1)
			tween.tween_callback(func(): removed_item.visible = false)
			tween.tween_callback(removed_item.queue_free)

	Globals.game_manager.add_to_grid(root_coords, scene)
	SignalBus.grid_updated.emit()

func _grid_updated():
	valid_recipes = []
	var grid = Globals.grid
	for grid_item_coords in grid.keys():
		var grid_item = grid[grid_item_coords]
		for recipe_item_key: GridItem.ItemType in recipes.keys():
			var recipe_item: Dictionary = recipes[recipe_item_key]
			var recipe_valid = true
			var recipe_parts = []
			for recipe_part_coords in recipe_item.keys():
				var recipe_part: GridItem.ItemType = recipe_item[recipe_part_coords]
				var target_item: GridItem = grid.get(grid_item_coords + recipe_part_coords)
				recipe_parts.append(grid_item_coords + recipe_part_coords)
				if target_item == null || target_item.type != recipe_part:
					recipe_valid = false
					break
			if recipe_valid:
				valid_recipes.append([recipe_parts, Globals.item_type_map.get(recipe_item_key)])
	print(valid_recipes)
	update_ui()
