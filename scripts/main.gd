
extends Node2D

var score: int = 0
var total_collectibles: int = 0
var power_mode: bool = false
var time_left: int = 90
var power_time_left: float = 0.0

@onready var score_label: Label = $"CanvasLayer/ScoreLabel"
@onready var time_label: Label = $"CanvasLayer/TimeLabel"
@onready var power_label: Label = $"CanvasLayer/PowerLabel"

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

	game_timer.timeout.connect(_on_game_timer_timeout)
	power_timer.timeout.connect(_on_power_timer_timeout)

	game_timer.start()

	if player.has_signal("player_died"):
		player.player_died.connect(_on_player_died)

	for e in enemies_node.get_children():
		if e.has_method("set_vulnerable"):
			e.set_vulnerable(false)


func _calculate_total_collectibles() -> void:
	total_collectibles = 0
	for item in items_node.get_children():
		if item.has_method("is_collectible") and item.is_collectible():
			total_collectibles += 1


func _update_score_label() -> void:
	score_label.text = "Score: %d" % score


func _update_time_label() -> void:
	time_label.text = "Tempo: %d" % time_left


func add_score(amount: int) -> void:
	score += amount
	_update_score_label()

	total_collectibles -= 1
	if total_collectibles <= 0:
		_on_all_collected()


func enemy_eaten(_ignored) -> void:
	score += 100   # SEMPRE 100, sem acúmulo
	_update_score_label()


func play_pick() -> void:
	if sfx_pickup:
		sfx_pickup.play()


func activate_power() -> void:
	power_mode = true
	time_left += 10
	_update_time_label()

	power_time_left = 5.0
	power_label.visible = true
	power_label.text = "Especial: %.1f" % power_time_left

	power_timer.stop()
	power_timer.start(5.0)

	for e in enemies_node.get_children():
		if e.has_method("set_vulnerable"):
			e.set_vulnerable(true)


func _on_power_timer_timeout() -> void:
	power_mode = false
	power_label.visible = false

	for e in enemies_node.get_children():
		if e.has_method("set_vulnerable"):
			e.set_vulnerable(false)


func _process(delta: float) -> void:
	if power_mode:
		power_time_left -= delta
		if power_time_left < 0:
			power_time_left = 0
		power_label.text = "Especial: %.1f" % power_time_left


func _on_game_timer_timeout() -> void:
	time_left -= 1
	_update_time_label()

	if time_left <= 0:
		_on_times_up()


func _on_all_collected() -> void:
	game_timer.stop()
	power_timer.stop()
	get_tree().change_scene_to_file("res://scenes/game_win.tscn")


func _on_times_up() -> void:
	game_timer.stop()
	power_timer.stop()
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func _on_player_died() -> void:
	if sfx_death:
		sfx_death.play()

	game_timer.stop()
	power_timer.stop()

	get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func game_over() -> void:
	if sfx_death:
		sfx_death.play()

	game_timer.stop()
	power_timer.stop()

	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
