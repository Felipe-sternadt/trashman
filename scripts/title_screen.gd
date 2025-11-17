extends Control

func _ready() -> void:
	$MarginContainer/HBoxContainer/VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
	$MarginContainer/HBoxContainer/VBoxContainer/LeaderboardButton.pressed.connect(_on_leaderboard_pressed)
	$MarginContainer/HBoxContainer/VBoxContainer/CreditsButton.pressed.connect(_on_credits_pressed)
	$MarginContainer/HBoxContainer/VBoxContainer/ExitButton.pressed.connect(_on_exit_pressed)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/user_screen.tscn")

func _on_leaderboard_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/leaderboard_screen.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()


	
