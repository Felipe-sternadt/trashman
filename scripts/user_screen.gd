extends Control


@onready var name_input: LineEdit = $NameInput

func _ready() -> void:
	name_input.grab_focus()


func _on_submit_button_pressed() -> void:
	var name := name_input.text.strip_edges()

	if name.length() < 1:
		print("❌ Nome inválido. Digite pelo menos 1 caractere.")
		return

	Global.player_name = name
	print("🔹 Nome salvo:", Global.player_name)

	get_tree().change_scene_to_file("res://scenes/level_select.tscn") 


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
