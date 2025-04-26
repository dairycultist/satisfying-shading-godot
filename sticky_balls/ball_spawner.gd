extends Node3D

const PARTICLE := preload("res://sticky_balls/ball.tscn")

var particles := []

func _ready() -> void:
	
	for x in range(10):
		var particle = PARTICLE.instantiate()
		add_child(particle)
		particle.position = Vector3(randfn(0.0, 0.4), randfn(0.0, 0.4), randfn(0.0, 0.4))
		particles.append(particle)
