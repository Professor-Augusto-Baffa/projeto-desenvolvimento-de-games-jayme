extends Area2D
const EXPLOSION = preload("res://Scenes/explosion.tscn")
@onready var rigid_body_2d = $RigidBody2D

var velocity = Vector2.ZERO
var force = Vector2.ZERO
var view = null

var ign_body = null
# Called when the node enters the scene tree for the first time.
func _ready():
	view = get_viewport().get_visible_rect().size

func initiate(accel_x, accel_y, x, y, body):
	ign_body = body
	position.x = x
	position.y = y
	force = Vector2(accel_x, accel_y)
	
func iniExp():
	var exp = EXPLOSION.instantiate()
	get_parent().add_child(exp)
	exp.initiate(position.x, position.y)
	queue_free()
	
func _on_body_entered(body):
	if body == ign_body:
		return
	iniExp()

func _physics_process(delta):
	velocity += force*delta
	velocity.x = clamp(velocity.x,-400,400)
	velocity.y = clamp(velocity.y,-400,400)
	position += velocity*delta
	if position.x >= view.x or position.x <= 0:
		iniExp()
	
	
	
	
