extends CharacterBody2D

@onready var spr = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var ray = $RayCast2D

# Lista de variables de stats player
var player_parameters := {
	"healt": 10,
	"maxHealt": 10,
	"stamina": 5,
	"maxStamina": 5
}
# Variables para el movimiento y salto
const SPEED = 150.0
const JUMP_VELOCITY = -300.0
# Variable de gravedad
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Variable de poder moverse
var canMove = true

func _physics_process(delta):
	fallGravity(delta)
	playerJump()
	playerDetectWall()
	playerClimb()
	playerMove()
	playerAnimation()

func fallGravity(delta):
	if canMove:
		# Si no esta en el suelo o haciendo colisión
		if not is_on_floor():
			# aumenta su velocidad hacia abajo
			velocity.y += gravity * delta

func playerJump():
	if canMove:
		# si presionas la tecla de salto y esta en el suelo
		if Input.is_action_just_pressed("move_jump") and is_on_floor():
			# aumenta su velocidad hacia arriba
			velocity.y = JUMP_VELOCITY

func playerDetectWall():
	if ray.is_colliding() and Input.is_action_just_pressed("move_climb"):
		canMove = false
	elif not ray.is_colliding():
		canMove = true

func playerClimb():
	if not canMove:	
		if Input.is_action_just_pressed("move_jump"):
			print("climb up")
			velocity.y = -SPEED
		elif Input.is_action_just_pressed("move_down"):
			print("climb down")
			velocity.y = SPEED
		else:
			pass
		move_and_slide()
	else:
		pass

func playerMove():
	if canMove:
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
		ray.rotation_degrees = 90
		anim.play("Run")
	elif Input.is_action_pressed("move_right"):
		spr.texture = load("res://sprites/character/Run.png")
		spr.flip_h = false
		ray.rotation_degrees = -90
		anim.play("Run")
	elif Input.is_action_pressed("move_jump") and not is_on_floor():
		spr.texture = load("res://sprites/character/Jump.png")
		anim.play("Jump")
	else:
		spr.texture = load("res://sprites/character/Idle.png")
		anim.play("Idle")
