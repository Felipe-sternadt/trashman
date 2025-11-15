extends CanvasLayer

@onready var level1_btn = $"Control/Level1Button"
@onready var back_btn = $"Control/BackButton"

func _ready():
	level1_btn.pressed.connect(_on_level1)
	back_btn.pressed.connect(_on_back)

func _on_level1():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_back():
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
