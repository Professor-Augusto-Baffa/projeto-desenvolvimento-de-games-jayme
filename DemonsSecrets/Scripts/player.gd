extends CharacterBody2D

@onready var polygon = $CollisionPolygon2D
@onready var animation = $AnimationPlayer
@onready var all_sprites = $sprites
@onready var bottomRay = $bottomRay
@onready var rightRay = $rightMoveRay

const SPEED = 275.0
const JUMP_VELOCITY = -350.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 0

func turnVisible(name):
	for node in all_sprites.get_children():
		if node.name == name:
			node.show()
		else:
			node.hide()

func flip_colision(direction):
	var sign_d = sign(direction)
	if sign_d == 0:
		return
	polygon.scale.x = sign_d * abs(polygon.scale.x)
	rightRay.scale.x = sign_d * abs(rightRay.scale.x)
	

func notOffScreen():
	var dots = polygon.polygon
	var x_neg = 0
	var x_pos = 0
	var view = get_viewport().get_visible_rect().size
	for dot in dots:
		if dot.x > x_pos:
			x_pos = dot.x
		if dot.x < x_neg:
			x_neg = dot.x
	if position.x + x_pos >= view.x:
		position.x = view.x - x_pos
		if velocity.x > 0:
			velocity.x = 0
	if position.x + x_neg <= 0:
		position.x = 0 - x_neg
		if velocity.x < 0:
			velocity.x = 0
			
func stop_on_frontier():
	var sign_d = sign(direction)
	var sign_v = sign(velocity.x)
	if sign_d == 0:
		return
	elif  sign_d*sign_v == 1 and rightRay.is_colliding():
		velocity.x = 0

func _physics_process(delta):
	if direction < 0 :
		for sprite in all_sprites.get_children():
			sprite.flip_h = true
	elif direction > 0:
		for sprite in all_sprites.get_children():
			sprite.flip_h = false
	flip_colision(direction)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	notOffScreen()
	stop_on_frontier()
	
	if is_on_floor():
		if velocity.x != 0:
			if animation.current_animation != "run":
				animation.play("run")
				turnVisible("run")
		else:
			if animation.current_animation != "idle":
				animation.play("idle")
				turnVisible("idle")	
	else:
		if velocity.y < 0:
			if animation.current_animation != "jump_up" and not bottomRay.is_colliding():
				animation.play("jump_up")
				turnVisible("jump")
		elif velocity.y > 0:
			if animation.current_animation != "jump_down" and not bottomRay.is_colliding():
				animation.play("jump_down")
				turnVisible("fall")
	
	move_and_slide()




	
