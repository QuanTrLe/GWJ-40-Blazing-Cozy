extends CPUParticles2D


func _ready():
	emit()


func set_emission_radius(radius):
	emission_sphere_radius = radius


func emit():
	emitting = true
	$Timer.start(lifetime)


func _on_Timer_timeout():
	queue_free()
