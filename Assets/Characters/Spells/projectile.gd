class_name Projectile
extends RigidBody2D
# Moving egg launched from the wand that can collide within the world

@export_range(0, 300, .2, "or_greater") var initial_velocity: float = 300.0


# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity.x = initial_velocity
