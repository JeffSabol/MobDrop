extends Node2D

@onready var point_light : PointLight2D = $"."
@onready var tween = get_tree().create_tween()

func _ready():
	# Start the glow effect when the scene starts
	glow_effect()

func glow_effect():
	print("inside gloweffect")
	# Animate the energy property of the light from 10 to 16 over 4 seconds
	tween.tween_property(point_light, "energy", 16, 4)

	# Optionally animate it back from 16 to 10 for a pulsing effect
	#tween.tween_property(point_light, "energy", 10, 4)
