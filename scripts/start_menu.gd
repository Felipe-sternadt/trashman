extends CanvasLayer


@onready var start_btn = $"Control/StartButton"
@onready var exit_btn = $"Control/ExitButton"
@onready var sfx = $StartSfx

func _ready():
	start_btn.pressed.connect(_on_start_pressed)
	exit_btn.pressed.connect(_on_exit_pressed)

func _on_start_pressed():
	if sfx and sfx.stream:
		sfx.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func _on_exit_pressed():
	get_tree().quit()
