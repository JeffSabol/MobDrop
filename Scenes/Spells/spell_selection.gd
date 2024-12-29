extends Control

@onready var root = get_tree().root
@onready var client_id = multiplayer.get_unique_id()
@onready var world = root.get_child(root.get_child_count() - 1)
@onready var player = world.get_node(str(client_id))

# Called when the node enters the scene tree for the first time.
func _ready():
	$".".mouse_filter = MOUSE_FILTER_IGNORE

	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_water_selection_area_mouse_entered():
	$Selector.texture = load("res://Assets/SpellSelect/WaterSelected.png")
	player.set_current_element(0)


func _on_fire_selection_area_mouse_entered():
	$Selector.texture = load("res://Assets/SpellSelect/FireSelected.png")
	player.set_current_element(1)


func _on_electric_selection_area_mouse_entered():
	$Selector.texture = load("res://Assets/SpellSelect/ElectricSelected.png")
	player.set_current_element(2)


func _on_earth_selection_area_mouse_entered():
	$Selector.texture = load("res://Assets/SpellSelect/EarthSelected.png")
	player.set_current_element(3)
