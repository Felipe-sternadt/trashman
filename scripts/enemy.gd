extends CharacterBody2D


@export var speed: float = 90.0
@export var chase_range: float = 300.0
@export var avoid_stuck_time: float = 0.4

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var dir_timer: Timer = $DirectionTimer
@onready var player = get_tree().get_first_node_in_group("player")

var vulnerable: bool = false
var direction: Vector2 = Vector2.RIGHT


func _ready() -> void:
	randomize()
	anim.play("normal")

	dir_timer.wait_time = avoid_stuck_time
	dir_timer.timeout.connect(_update_direction)
	dir_timer.start()


func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

	if is_on_wall():
		_pick_random_direction()


func _update_direction() -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		return

	var dist = global_position.distance_to(player.global_position)

	if vulnerable:
		direction = (global_position - player.global_position).normalized()
		return

	if dist < chase_range:

		# CORREÇÃO AQUI — ESTA LINHA ESTAVA QUEBRADA
		var vec = (player.global_position - global_position).normalized()

		var dx = 0.0
		var dy = 0.0

		if vec.x == 0.0:
			dx = 0.0
		else:
			dx = sign(vec.x)

		if vec.y == 0.0:
			dy = 0.0
		else:
			dy = sign(vec.y)

		direction = Vector2(dx, dy).normalized()
	else:
		_pick_random_direction()


func _pick_random_direction() -> void:
	var dirs = [
		Vector2.RIGHT,
		Vector2.LEFT,
		Vector2.UP,
		Vector2.DOWN
	]
	direction = dirs[randi() % dirs.size()]


func set_vulnerable(v: bool) -> void:
	vulnerable = v
	if v:
		anim.play("scared")
	else:
		anim.play("normal")


func is_vulnerable() -> bool:
	return vulnerable


func on_eaten() -> void:
	queue_free()
