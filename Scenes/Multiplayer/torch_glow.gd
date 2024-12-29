# Jeff Sabol
extends Node2D

@onready var point_light : PointLight2D = $"."
@onready var tween = get_tree().create_tween()

func _ready():
	# Start the glow effect when the scene starts
	glow_effect()

func glow_effect():
	# Animate the energy property of the light
	tween.set_loops()
	tween.tween_property(point_light, "energy", 16, 4)
	tween.tween_property(point_light, "energy", 3, 4)
