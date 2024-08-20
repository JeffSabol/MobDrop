extends Node2D


@export var dragon: PackedScene  = preload("res://Scenes/Enemies/dragon.tscn")
@export var spawn_position: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	print("spawn dragon")
	if dragon:
		var drag = dragon.instantiate()
		drag.position = spawn_position
		add_child(drag)
	else:
		null
