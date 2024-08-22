extends CharacterBody2D

const SPEED = 120.0
const JUMP_VELOCITY = -300.0

# Enums and variables
enum PlayerState {IDLE, RUN, CAST, JUMP, FALLING, DASH, DEATH} 
var state = PlayerState.IDLE
var spell_scene = preload("res://Scenes/Spells/spell.tscn")
var alternate_spell_scene = preload("res://Scenes/Spells/spell2.tscn") # Alternate spell for right-click
var health = 3

func _physics_process(delta: float) -> void:
	# Add gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		state = PlayerState.JUMP
		velocity.y = JUMP_VELOCITY

	# Handle movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Determine vertical state (jumping, falling).
	if velocity.y < 0:
		state = PlayerState.JUMP
	elif velocity.y > 0:
		state = PlayerState.FALLING
	
	# Determine horizontal state (idle, run).
	if velocity.x == 0 and velocity.y == 0 and state != PlayerState.CAST and state != PlayerState.DEATH:
		state = PlayerState.IDLE
	elif velocity.x != 0 and velocity.y == 0:
		state = PlayerState.RUN

	update_animations()
	move_and_slide()

# Update animations based on player state
func update_animations():
	match state:
		PlayerState.IDLE:
			$AnimatedSprite2D.play("default")
		PlayerState.RUN:
			$AnimatedSprite2D.flip_h = velocity.x < 0
			$AnimatedSprite2D.play("run")
		PlayerState.CAST:
			$AnimatedSprite2D.play("cast")
		PlayerState.FALLING:
			$AnimatedSprite2D.play("fall")
		PlayerState.JUMP:
			$AnimatedSprite2D.play("jump")
		PlayerState.DASH:
			$AnimatedSprite2D.play("dashup")
		PlayerState.DEATH:
			$AnimatedSprite2D.play("death")

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			cast_spell(event.position, false)  # Left-click casts the default spell
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			cast_spell(event.position, true)  # Right-click casts the alternate spell

func cast_spell(position, is_alternate_spell: bool):
	# Convert the screen position to the world position
	var world_position = get_global_mouse_position()
	
	# Choose the spell scene based on the mouse button clicked
	var spell_instance = null
	if is_alternate_spell:
		spell_instance = alternate_spell_scene.instantiate()
	else:
		spell_instance = spell_scene.instantiate()
		
	spell_instance.position = world_position
	get_parent().add_child(spell_instance)  # Add the spell to the parent (Game Node)

func hurt_player():
	health -= 1
	# Change the heart to black
	if health == 2:
		$"../HUD/HBoxContainer/Heart3".set_texture(load("res://Assets/Characters/Wizard/HeartBlack.png"))
	if health == 1:
		$"../HUD/HBoxContainer/Heart2".set_texture(load("res://Assets/Characters/Wizard/HeartBlack.png"))
	if health == 0:
		$"../HUD/HBoxContainer/Heart1".set_texture(load("res://Assets/Characters/Wizard/HeartBlack.png"))
	if health <= 0:
		kill_player()

func kill_player():
	velocity.x = 0
	state = PlayerState.DEATH
	await get_tree().create_timer(0.6).timeout
	game_over()

func game_over():
	get_tree().quit()
