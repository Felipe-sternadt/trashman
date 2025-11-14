extends Node2D

var score: int = 0
var total_collectibles: int = 0
var power_mode: bool = false
var time_left: int = 90  # segundos

@onready var score_label: Label = $"CanvasLayer/ScoreLabel"
@onready var time_label: Label = $"CanvasLayer/TimeLabel"

@onready var power_timer: Timer = $PowerTimer
@onready var game_timer: Timer = $GameTimer

@onready var items_node: Node = $Items
@onready var enemies_node: Node = $Enemies
@onready var player: Node = $Player

@onready var sfx_pickup: AudioStreamPlayer = $PickupSfx
@onready var sfx_death: AudioStreamPlayer = $DeathSfx


func _ready() -> void:
	_calculate_total_collectibles()
	_update_score_label()
	_update_time_label()

	# conecta timers
	game_timer.timeout.connect(_on_game_timer_timeout)
	power_timer.timeout.connect(_on_power_timer_timeout)

	# garante que o timer de jogo comece (não depende de Autostart no editor)
	game_timer.start()

	# conecta sinal de morte do player
	if player.has_signal("player_died"):
		player.player_died.connect(_on_player_died)

	# inimigos começam não vulneráveis
	for e in enemies_node.get_children():
		if e.has_method("set_vulnerable"):
			e.set_vulnerable(false)


func _calculate_total_collectibles() -> void:
	total_collectibles = 0
	for item in items_node.get_children():
		if item.has_method("is_collectible") and item.is_collectible():
			total_collectibles += 1


func _update_score_label() -> void:
	if score_label:
		score_label.text = "Score: %d" % score


func _update_time_label() -> void:
	if time_label:
		time_label.text = "Tempo: %d" % time_left


func add_score(amount: int) -> void:
	score += amount
	_update_score_label()

	total_collectibles -= 1
	if total_collectibles <= 0:
		_on_all_collected()


func enemy_eaten(points: int) -> void:
	score += points
	_update_score_label()


func play_pick() -> void:
	if sfx_pickup and sfx_pickup.stream:
		sfx_pickup.play()


func activate_power() -> void:
	power_mode = true

	# +10 segundos no timer
	time_left += 10
	_update_time_label()

	power_timer.stop()
	power_timer.start(3.0)

	for e in enemies_node.get_children():
		if e.has_method("set_vulnerable"):
			e.set_vulnerable(true)


func _on_power_timer_timeout() -> void:
	power_mode = false
	for e in enemies_node.get_children():
		if e.has_method("set_vulnerable"):
			e.set_vulnerable(false)


func _on_game_timer_timeout() -> void:
	time_left -= 1
	_update_time_label()

	if time_left <= 0:
		_on_times_up()


func _on_all_collected() -> void:
	# NÃO toca música de win aqui – isso é só na tela game_win
	game_timer.stop()
	power_timer.stop()

	get_tree().change_scene_to_file("res://scenes/game_win.tscn")


func _on_times_up() -> void:
	# NÃO toca música de gameover aqui – só na tela game_over
	game_timer.stop()
	power_timer.stop()

	get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func _on_player_died() -> void:
	# Som de morte toca na própria fase
	if sfx_death and sfx_death.stream:
		sfx_death.play()
		await sfx_death.finished

	game_timer.stop()
	power_timer.stop()

	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
