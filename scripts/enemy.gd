extends CharacterBody2D

@export var speed: float = 120.0
@export var chase_range: float = 800.0
@export var avoid_stuck_time: float = 0.25
@export var vulnerable_speed: float = 60.0   

var vulnerable: bool = false
var direction: Vector2 = Vector2.RIGHT
var player: Node = null

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var dir_timer: Timer = $DirectionTimer
@onready var hitbox: Area2D = $HitboxEnemy


func _ready() -> void:
	randomize()
	player = get_tree().get_first_node_in_group("player")
	anim.play("normal")

	dir_timer.wait_time = avoid_stuck_time
	dir_timer.timeout.connect(_update_direction)
	dir_timer.start()

	hitbox.body_entered.connect(_on_HitboxEnemy_body_entered)


func _physics_process(delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("player")

	var current_speed = speed
	if vulnerable:
		current_speed = vulnerable_speed

	velocity = direction * current_speed
	move_and_slide()

	if is_on_wall():
		_pick_random_direction()


func _update_direction() -> void:
	if player == null:
		return

	var dist := global_position.distance_to(player.global_position)

	
	if vulnerable:
		var flee_vec = (global_position - player.global_position).normalized()
		direction = direction.lerp(flee_vec, 0.3).normalized()
		return

	
	if dist <= chase_range:
		var vec = player.global_position - global_position

		if abs(vec.x) > abs(vec.y):
			direction = Vector2(sign(vec.x), 0)
		else:
			direction = Vector2(0, sign(vec.y))

		direction = direction.normalized()
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


func _on_HitboxEnemy_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return

	var m = get_tree().current_scene

	
	if not vulnerable:
		if m and m.has_method("game_over"):
			m.game_over()
		return

	
	if vulnerable:
		if m and m.has_method("enemy_eaten"):
			m.enemy_eaten(100)  
		on_eaten()


func on_eaten() -> void:
	queue_free()
