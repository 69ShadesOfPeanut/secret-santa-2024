# Script that handles the sign
extends PopupPanel


func CloseButton() -> void:
	# Play audio
	Audio.PlaySFX("Click")
	
	get_tree().paused = false
	queue_free()

## Called when popup is hidden
## Return the popup
func PopupHidden() -> void:
	show()
