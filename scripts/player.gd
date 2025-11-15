extends CharacterBody2D

signal player_died

@export var speed: float = 165.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var detector: Area2D = $Area2D

var alive: bool = true
var dir: Vector2 = Vector2.ZERO


func _ready() -> void:
	var frames = SpriteFrames.new()

	# RIGHT
	frames.add_animation("right")
	frames.set_animation_loop("right", true)
	frames.add_frame("right", load("res://assets/sprites/player/right_1.png"))
	frames.add_frame("right", load("res://assets/sprites/player/right_2.png"))
	frames.add_frame("right", load("res://assets/sprites/player/right_3.png"))

	# LEFT
	frames.add_animation("left")
	frames.set_animation_loop("left", true)
	frames.add_frame("left", load("res://assets/sprites/player/left_1.png"))
	frames.add_frame("left", load("res://assets/sprites/player/left_2.png"))
	frames.add_frame("left", load("res://assets/sprites/player/left_3.png"))

	# UP
	frames.add_animation("up")
	frames.set_animation_loop("up", true)
	frames.add_frame("up", load("res://assets/sprites/player/up_1.png"))
	frames.add_frame("up", load("res://assets/sprites/player/up_2.png"))
	frames.add_frame("up", load("res://assets/sprites/player/up_3.png"))

	# DOWN
	frames.add_animation("down")
	frames.set_animation_loop("down", true)
	frames.add_frame("down", load("res://assets/sprites/player/down_1.png"))
	frames.add_frame("down", load("res://assets/sprites/player/down_2.png"))
	frames.add_frame("down", load("res://assets/sprites/player/down_3.png"))

	# DIE
	frames.add_animation("die")
	frames.set_animation_loop("die", false)
	frames.add_frame("die", load("res://assets/sprites/player/death.png"))

	anim.frames = frames
	anim.play("right")

	detector.body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	if not alive:
		return

	dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if dir.length() > 0.0:
		velocity = dir.normalized() * speed

		if abs(dir.x) > abs(dir.y):
			if dir.x > 0.0:
				anim.play("right")
			else:
				anim.play("left")
		else:
			if dir.y > 0.0:
				anim.play("down")
			else:
				anim.play("up")
	else:
		velocity = Vector2.ZERO

	move_and_slide()


func _on_body_entered(body: Node) -> void:
	if not alive:
		return

	if body.is_in_group("enemies"):

		# Player COME inimigo vulnerável → +100 pontos
		if body.has_method("is_vulnerable") and body.is_vulnerable():

			if body.has_method("on_eaten"):
				body.on_eaten()

			var m = get_tree().current_scene
			if m and m.has_method("enemy_eaten"):
				m.enemy_eaten(100)  # 100 PONTOS POR INIMIGO
			return

		# Player MORRE
		alive = false
		anim.play("die")
		anim.animation_finished.connect(_on_death_animation_finished)


func _on_death_animation_finished() -> void:
	emit_signal("player_died")
