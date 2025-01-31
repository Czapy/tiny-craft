class_name GridItem
extends Node2D

enum ItemType {
	TREE = 0,
	ROCK = 1,
	WOOD = 2,
	STONE = 3,
	STICK = 4,
	AXE = 5
}

@export var type: ItemType
@export var label: String

var curve: Curve = preload("res://scenes/curve.tres")

func _ready() -> void:
	tween_spawn()
	$Sprite2D/Area2D.connect("mouse_entered", SignalBus.clickable_hovered.emit)
	$Sprite2D/Area2D.connect("mouse_exited", SignalBus.clickable_exited.emit)

func tween_spawn():
	var original_scale = scale;
	scale = Vector2.ZERO
	create_tween()\
		.tween_property(self, "scale", original_scale, 0.5)\
		.from(Vector2.ZERO)\
		.set_custom_interpolator(tween_curve)\
		.set_ease(Tween.EASE_IN_OUT)

func tween_curve(v):
	return curve.sample_baked(v)
