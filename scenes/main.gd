extends Node2D

var TreeScn = preload("res://scenes/tree/tree.tscn")
var StoneScn = preload("res://scenes/stone.tscn")

func _ready() -> void:
	Globals.land = $Land
	Globals.main = self
	
	Globals.addToGrid(Vector2i(-1, -1), TreeScn)
	Globals.addToGrid(Vector2i(1, -1), StoneScn)
	pass
