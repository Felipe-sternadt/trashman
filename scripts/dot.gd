extends Area2D

func _ready():
	body_entered.connect(_on_enter)

func _on_enter(body):
	# ⬇️ NOVO: garante que só o player coleta
	if not body.is_in_group("player"):
		return

	# ⬇️ daqui pra baixo continua igual
	var m = get_tree().current_scene
	if m and m.has_method("add_score"):
		m.add_score(1)
	if m and m.has_method("play_pick"):
		m.play_pick()
	queue_free()

func is_collectible() -> bool:
	return true
