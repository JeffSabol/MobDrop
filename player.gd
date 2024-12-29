# Jeff Sabol
extends CharacterBody2D

@export var SPEED = 160.0
@export var JUMP_VELOCITY = -500.0

enum PlayerState {IDLE, RUN, CAST, JUMP, FALLING, DASH, DEATH} 
enum CurrentElement {WATER, FIRE, ELECTRIC, EARTH}

@export var shooter: Shooter

var state: PlayerState = PlayerState.IDLE
# The default element
@export var current_element = CurrentElement.WATER
var is_selecting_spell: bool = false
var spell_selection_menu: Control = null

var water_spell_1 = preload("res://Scenes/Spells/water_spell_1.tscn")
var fire_spell_1 = preload("res://Scenes/Spells/fire_spell_1.tscn")
var electric_spell_1 = preload("res://Scenes/Spells/electric_spell_1.tscn")
var earth_spell_1 = preload("res://Scenes/Spells/earth_spell_1.tscn")
var spell_scene = preload("res://Scenes/Spells/spell.tscn")
var alternate_spell_scene = preload("res://Scenes/Spells/spell2.tscn")
@export var health = 3

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		apply_physics(delta)

	move_and_slide()

func apply_physics(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if (Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_select")) and is_on_floor():
		set_state(PlayerState.JUMP)
		velocity.y = JUMP_VELOCITY

	# Handle movement/deceleration
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Determine vertical state
	if velocity.y < 0:
		set_state(PlayerState.JUMP)
	elif velocity.y > 0:
		set_state(PlayerState.FALLING)

	# Determine horizontal state
	if velocity.x == 0 and velocity.y == 0 and state != PlayerState.CAST and state != PlayerState.DEATH:
		set_state(PlayerState.IDLE)
	elif velocity.x != 0 and velocity.y == 0:
		set_state(PlayerState.RUN)
		
	# Handle spell selection
	if Input.is_action_pressed("spell_select"):
		var root = get_tree().root
		var world = root.get_child(root.get_child_count() - 1)
		
		if not is_selecting_spell:
			spell_selection_menu = load("res://Scenes/Spells/spell_selection.tscn").instantiate()
			var client_id = multiplayer.get_unique_id()
			world.get_node(str(client_id)).add_child(spell_selection_menu)
			
		is_selecting_spell = true
	
	# Hide the spell selection menu
	if Input.is_action_just_released("spell_select"):
		spell_selection_menu.hide()
		is_selecting_spell = false
		
	# Handle the projectile shooting
	if Input.is_action_just_pressed("shoot"):
		shooter.try_shoot()
	
	update_animations()

func update_animations() -> void:
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

func set_state(new_state: PlayerState) -> void:
	if state != new_state:
		state = new_state
		update_animations()
		if is_multiplayer_authority():
			rpc("sync_state", new_state)

# Function to synchronize state across clients
@rpc("any_peer")
func sync_state(new_state: PlayerState) -> void:
	state = new_state
	update_animations()

func cast_spell(position, spell_type) -> void:
	if is_multiplayer_authority():
		spawn_spell(position, current_element)
	rpc("spawn_spell", position, current_element)

# Function to spawn spell instance across clients
@rpc("any_peer")
func spawn_spell(world_position, current_element) -> void:
	# TODO add in spell choosing based off selection
	var spell_instance = water_spell_1.instantiate()
	match(current_element):
		CurrentElement.WATER:
			spell_instance = water_spell_1.instantiate()
		CurrentElement.FIRE:
			spell_instance = fire_spell_1.instantiate()
		CurrentElement.EARTH:
			spell_instance = earth_spell_1.instantiate()
		CurrentElement.ELECTRIC:
			spell_instance = electric_spell_1.instantiate()
	spell_instance.position = world_position
	get_parent().add_child(spell_instance)

func hurt_player() -> void:
	health -= 1
	if is_multiplayer_authority():
		rpc("sync_health", health)

# Function to synchronize health across clients
@rpc("any_peer")
func sync_health(new_health) -> void:
	health = new_health
	if health <= 0:
		kill_player()

func kill_player() -> void:
	velocity.x = 0
	set_state(PlayerState.DEATH)
	await get_tree().create_timer(0.6).timeout
	game_over()

func game_over() -> void:
	get_tree().quit()

func set_current_element(element_type):
	match(element_type):
		CurrentElement.WATER:
			current_element = CurrentElement.WATER
		CurrentElement.FIRE:
			current_element = CurrentElement.FIRE
		CurrentElement.ELECTRIC:
			current_element = CurrentElement.ELECTRIC
		CurrentElement.EARTH:
			current_element = CurrentElement.EARTH
