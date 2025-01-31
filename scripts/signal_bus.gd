extends Node

signal mine(coords: Vector2i)
signal move(coords: Vector2i)

signal grid_updated
signal mining_finished(item: Farmable)

signal clickable_hovered
signal clickable_exited
