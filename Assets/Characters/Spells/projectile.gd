class_name Projectile
extends RigidBody2D
# Moving egg launched from the wand that can collide within the world

@export_range(0, 300, .2, "or_greater") var initial_velocity: float = 450.0

func launch(p_move_direction: Vector2):
	linear_velocity = initial_velocity * p_move_direction
