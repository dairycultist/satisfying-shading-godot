extends Node3D

const PARTICLE := preload("res://liquid_particle.tscn")

var particles := []

func _ready() -> void:
	
	for x in range(10):
		var particle = PARTICLE.instantiate()
		add_child(particle)
		particle.position = Vector3(randfn(0.0, 0.4), randfn(0.0, 0.4), randfn(0.0, 0.4))
		particles.append(particle)

func _process(delta: float) -> void:
	
	for particle in particles:
		
		for other in particles:
			
			if particle == other:
				continue
			
			# attract to nearby particles
			var difference = particle.position - other.position
			var magnitude = difference.length()
			
			if magnitude > 1:
				continue
			
			var direction = difference.normalized()
			
			particle.add_constant_force(direction * delta * -0.1)
