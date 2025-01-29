class_name GridItem
extends Node2D

enum ItemType {WOOD, STONE}

@export var type: ItemType
var curve: Curve = preload("res://scenes/curve.tres")

func tween_curve(v):
	return curve.sample_baked(v)

func _ready() -> void:
	var original_scale = scale;
	scale = Vector2.ZERO
	var tween = create_tween()\
		.tween_property(self, "scale", original_scale, 0.5)\
		.from(Vector2.ZERO)\
		.set_custom_interpolator(tween_curve)\
		.set_delay(randf_range(0, 0.5))\
		.set_ease(Tween.EASE_IN_OUT)
		#.set_trans(Tween.TRANS_CIRC)
