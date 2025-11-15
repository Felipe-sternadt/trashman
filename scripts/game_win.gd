extends CanvasLayer

@onready var retry_btn = $"Control/RetryButton"
@onready var exit_btn = $"Control/ExitButton"
@onready var auto_timer = $AutoReturnTimer

func _ready():
	retry_btn.pressed.connect(_on_retry)
	exit_btn.pressed.connect(_on_exit)
	auto_timer.timeout.connect(_on_timeout)

func _on_retry():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_exit():
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_timeout():
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
