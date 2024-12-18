# Script that handles the audio of the game
extends Node

# Vars
@onready var SFX := {
	"Click": preload("res://Resources/Sounds/Click.ogg")
}
# Nodes
@onready var SFXStreamPlayer : AudioStreamPlayer = get_node("SFX")


## Called when SFX needs to be played
func PlaySFX(SFXName : String):
	var SelectedSFX = SFX[SFXName]
	
	SFXStreamPlayer.set_stream(SelectedSFX)
	SFXStreamPlayer.play()
