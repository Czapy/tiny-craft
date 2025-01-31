extends Node2D

var TreeScn = preload("res://scenes/tree.tscn")
var StoneScn = preload("res://scenes/rock.tscn")

func _ready() -> void:
	Globals.game_manager = $GameManager
	Globals.recipe_manager = $RecipeManager
	
	Globals.game_manager.add_to_grid(Vector2i(-1, -1), TreeScn)
	Globals.game_manager.add_to_grid(Vector2i(1, -1), StoneScn)
	
	#$Main/Land.set_cells_terrain_connect([Vector2i(2, 0)], 0, 0)
