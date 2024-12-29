class_name Shooter
extends RayCast2D
# Launches projectiles

@export var fireable: Fireable
@export var projectiles_parent_group = "projectile_parent"
@export var default_direction = Vector2.RIGHT

var projectiles_node: Node

func _ready():
	projectiles_node = get_tree().get_first_node_in_group(projectiles_parent_group)
	assert(projectiles_node != null, "Projectiles node is required for this script to work.")

func try_shoot() -> bool:
	if not is_colliding():
		_shoot()
		return true

	return false

func _shoot():
	var projectile = fireable.scene.instantiate()
	projectiles_node.add_child(projectile)
	projectile.name = fireable.display_name
	projectile.global_position = global_position
	var launch_direction = default_direction.rotated(global_rotation)
	projectile.launch(launch_direction)
