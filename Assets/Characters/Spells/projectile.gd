class_name Projectile
extends RigidBody2D
# Moving egg launched from the wand that can collide within the world

@export_range(0, 300, .2, "or_greater") var initial_velocity: float = 450.0
var this_position = Vector2(0,0)

func _physics_process(delta):
	this_position = position

func launch(p_move_direction: Vector2):
	linear_velocity = initial_velocity * p_move_direction

func _integrate_forces(state):
	# Check if the projectile has stopped moving
	if linear_velocity.x < 50 and linear_velocity.x > 0 or linear_velocity.x > -50 and linear_velocity.x < 0:
		var root = get_tree().root
		var world = root.get_child(root.get_child_count() - 1)
		var client_id = multiplayer.get_unique_id()
		var player = world.get_node(str(client_id))
		player.cast_spell(this_position, player.current_element)
		queue_free()
		
