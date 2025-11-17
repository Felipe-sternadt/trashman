extends Node


var player_name: String = ""

func _ready() -> void:
  SilentWolf.configure({
	"api_key": "k7SR0vMYT2cAR2dXEyFH1j3eZO7wpA547g3mpzxd",
	"game_id": "trashman",
	"log_level": 1
  })

  SilentWolf.configure_scores({
	"open_scene_on_close": "res://scenes/title_screen.tscn"
  })
