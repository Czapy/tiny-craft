extends Node2D

var TreeScn = preload("res://scenes/tree.tscn")
var StoneScn = preload("res://scenes/stone.tscn")

func _ready() -> void:
	Globals.game_manager = $"../GameManager"

	Globals.game_manager.addToGrid(Vector2i(-1, -1), TreeScn)
	Globals.game_manager.addToGrid(Vector2i(1, -1), StoneScn)
	pass
