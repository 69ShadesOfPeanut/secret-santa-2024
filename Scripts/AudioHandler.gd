# Script that handles the audio of the game
extends Node

# Vars
# Sound effects
@onready var SFX := {
	"Click": preload("res://Resources/Sounds/Click.ogg"),
	"Hurt": preload("res://Resources/Sounds/Hurt.wav"),
	"Death": preload("res://Resources/Sounds/Death.wav"),
	"Chest": preload("res://Resources/Sounds/Chest.wav")
}
# Dungeon music
@onready var DungeonMusic := {
}
# Battle music
@onready var BattleMusic := {
}
# Nodes
@onready var SFXStreamPlayer : AudioStreamPlayer = get_node("SFX")
@onready var DungeonMusicPlayer : AudioStreamPlayer = get_node("DungeonMusic")
@onready var BattleMusicPlayer : AudioStreamPlayer = get_node("BattleMusic")


## Onready start dungeon music
func _ready() -> void:
	DungeonMusicPlayer.play()

## Called when SFX needs to be played
func PlaySFX(SFXName : String):
	var SelectedSFX = SFX[SFXName]
	
	SFXStreamPlayer.set_stream(SelectedSFX)
	SFXStreamPlayer.play()

## Called to switch between battle and dungeon music
func MusicSwitch(Battle : bool):
	if Battle == true:
		DungeonMusicPlayer.stop()
		BattleMusicPlayer.play()
	else:
		DungeonMusicPlayer.play()
		BattleMusicPlayer.stop()
