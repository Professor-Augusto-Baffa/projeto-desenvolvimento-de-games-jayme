extends Node2D
@onready var gpu_particles_2d = $GPUParticles2D

func initiate(x, y):
	position.x = x
	position.y = y
	gpu_particles_2d.emitting = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
