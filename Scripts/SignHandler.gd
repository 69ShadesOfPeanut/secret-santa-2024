# Script that handles the sign
extends PopupPanel


func CloseButton() -> void:
	get_tree().paused = false
	queue_free()
