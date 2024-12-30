extends Node2D

@export var monster: PackedScene = preload("res://Scenes/Enemies/eyeball_green.tscn")
@export var spawn_position: Vector2 = Vector2.ZERO
@export var max_spawn_count: int = 10

var spawn_count: int = 0

func _on_timer_timeout() -> void:
	# Check if we've reached the spawn limit
	if spawn_count < max_spawn_count:
		if monster:
			var mob = monster.instantiate()
			mob.position = spawn_position
			add_child(mob)
			spawn_count += 1
	else:
		$Timer.stop()
