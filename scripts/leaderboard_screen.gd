extends Control

var player_name
var score = 0

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")





func _on_submit_button_pressed() -> void:
	if $LineEdit.text != "":
		player_name = $LineEdit.text
		SilentWolf.Scores.save_score(player_name, score)
		get_tree().change_scene_to_file("res://addons/silent_wolf/Scores/Leaderboard.tscn")


func _on_count_button_pressed() -> void:
	score += 1
	$CountButton.text = str(score) 
