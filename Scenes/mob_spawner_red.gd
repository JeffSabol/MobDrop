extends Node2D

@export var monster: PackedScene  = preload("res://Scenes/Enemies/eyeball_red.tscn")
@export var spawn_position: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	print("spawn red monster")
	if monster:
		var mob = monster.instantiate()
		mob.position = spawn_position
		add_child(mob)
	else:
		null
