class_name Farmable
extends GridItem

@onready var progress_bar: ProgressBar = $ProgressBar

@export var drop: Node2D
@export_range(0.0, 5.0, 0.1) var mining_time = 1.0

var timer: SceneTreeTimer

func _process(delta: float) -> void:
	if timer:
		progress_bar.value = 1 - timer.time_left/mining_time

func mine():
	if not timer:
		progress_bar.visible = true
		timer = get_tree().create_timer(mining_time)
		timer.timeout.connect(_on_mining_finished)

func _on_mining_finished():
	timer = null
	progress_bar.visible = false
	progress_bar.value = 0
	# TODO emit spawn drop, game manager should decide on which free neighbouring tile to put it
