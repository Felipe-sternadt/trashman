extends Control

func _ready() -> void:

	$MarginContainer/HBoxContainer/VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
	$MarginContainer/HBoxContainer/VBoxContainer/CreditsButton.pressed.connect(_on_credits_pressed)
	$MarginContainer/HBoxContainer/VBoxContainer/ExitButton.pressed.connect(_on_exit_pressed)


func _on_start_pressed() -> void:
	# AGORA vai para a seleção de fase, NÃO para o main!
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")


func _on_credits_pressed() -> void:
	print("⚠ Tela de créditos ainda não implementada!")


func _on_exit_pressed() -> void:
	get_tree().quit()
