extends AnimatedSprite2D

var damage = 10

func _ready():
	play("cast")  # Play the initial animation
	$Timer.start()  # Start a timer if you want to auto-destroy

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemies"):  # Assuming enemies are in this group
		body.take_damage(damage)
		queue_free()  # Destroy the spell after it hits an enemy

func _on_timer_timeout() -> void:
	queue_free()  # Destroy the spell after the animation ends
