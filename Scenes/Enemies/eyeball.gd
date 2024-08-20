extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var health = 10
var direction = -1
var is_dying = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

	if health <= 0:
		die()

	# Check if the enemy has hit an obstacle and reverse direction
	if velocity.x == 0 && !is_dying:
		direction *= -1
		velocity.x = 75 * direction
		$AnimatedSprite2D.scale.x *= -1  # Flip the sprite direction

func die():
	is_dying = true
	$".".velocity.x = 0
	$AnimatedSprite2D.play("death")

func take_damage(damage: int):
	health -= damage
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _on_dragon_body_entered(body: Node2D) -> void:
	# TODO hurt the player
	if body.name == "Player":
		body.hurt_player()
		#Invalid call. Nonexistent function 'get_parent_node' in base 'CharacterBody2D (player.gd)'.
#		print("body.get_parent_node(): " + body.get_parent_node())

		print("hurt player!")
