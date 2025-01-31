extends Node2D

@export var grid = {}
@export var game_manager: GameManager
@export var recipe_manager: RecipeManager

@export var item_type_map: Dictionary = {
	GridItem.ItemType.TREE: preload("res://scenes/tree.tscn"),
	GridItem.ItemType.ROCK: preload("res://scenes/rock.tscn"),
	GridItem.ItemType.WOOD: preload("res://scenes/wood.tscn"),
	GridItem.ItemType.STONE: preload("res://scenes/stone.tscn"),
	GridItem.ItemType.STICK: preload("res://scenes/stick.tscn"),
	GridItem.ItemType.AXE: preload("res://scenes/axe.tscn")
}
