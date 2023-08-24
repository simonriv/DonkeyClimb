extends CharacterBody2D

@onready var spr = $Sprite2D
@onready var anim = $AnimationPlayer

# Variables para el movimiento y salto
const SPEED = 150.0
const JUMP_VELOCITY = -300.0
# Variable de gravedad
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	fallGravity(delta)
	playerJump()
	playerMove()
	playerAnimation()

func fallGravity(delta):
	# Si no esta en el suelo o haciendo colisión
	if not is_on_floor():
		# aumenta su velocidad hacia abajo
		velocity.y += gravity * delta

func playerJump():
	# si presionas la tecla de salto y esta en el suelo
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		# aumenta su velocidad hacia arriba
		velocity.y = JUMP_VELOCITY

func playerMove():
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func playerAnimation():
	if Input.is_action_pressed("move_left"):
		spr.texture = load("res://sprites/character/Run.png")
		spr.flip_h = true
		anim.play("Run")
	elif Input.is_action_pressed("move_right"):
		spr.texture = load("res://sprites/character/Run.png")
		spr.flip_h = false
		anim.play("Run")
	elif Input.is_action_pressed("move_jump") and not is_on_floor():
		spr.texture = load("res://sprites/character/Jump.png")
		anim.play("Jump")
	else:
		spr.texture = load("res://sprites/character/Idle.png")
		anim.play("Idle")
