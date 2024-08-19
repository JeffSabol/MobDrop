extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Enums and variables
enum PlayerState {IDLE, RUN, CAST, JUMP, FALLING, DASH, DEATH} 
var state = PlayerState.IDLE

func _physics_process(delta: float) -> void:
	print(velocity)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		state = PlayerState.JUMP
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Going up or down
	if velocity.y < 0:
		state = PlayerState.JUMP
	if velocity.y > 0:
		state = PlayerState.FALLING
	
	# Standing still
	if velocity.x == 0 and velocity.y == 0:
		state = PlayerState.IDLE
		
	# Running left or right
	if (velocity.x < 0 or velocity.x > 0) && velocity.y == 0:
		state = PlayerState.RUN

	update_animations()
	move_and_slide()

# Update animations based on player state
func update_animations():
	if state == PlayerState.IDLE:
		$AnimatedSprite2D.play("default")
	elif state == PlayerState.RUN:
		$AnimatedSprite2D.flip_h = velocity.x < 0
		$AnimatedSprite2D.play("run")
	elif state == PlayerState.CAST:
		$AnimatedSprite2D.play("cast")
	elif state == PlayerState.FALLING:
		$AnimatedSprite2D.play("fall")
	elif state == PlayerState.JUMP:
		$AnimatedSprite2D.play("jump")
	elif state == PlayerState.DASH:
		$AnimatedSprite2D.play("dashup")
	elif state == PlayerState.DEATH:
		$AnimatedSprite2D.play("death")
	
