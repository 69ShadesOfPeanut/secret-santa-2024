# Script that handles the player picking what monster type they want
extends Control

# Vars
# Nodes
@onready var PlayerCharacter = get_node("/root/DungeonStart/PlayerCharacter")
@onready var MonsterPickInteractable = get_node("/root/DungeonStart/MonsterPickInteractable")
@onready var ConfirmationLabel : Label = get_node("%ConfirmationLabel")
@onready var MonsterPickWindow : Window = get_node("MonsterPick")
@onready var ConfirmationWindow : Window = get_node("ConfirmationWindow")
@onready var TutorialWindow : Window = get_node("TutorialWindow")


## Called when user presses a type button
## Brings up confirmation button and sets player monster type
func ButtonPressed(Type : String):
	print(Type + " pressed")
	
	# Play audio
	Audio.PlaySFX("Click")
	
	# Sets the monster type
	CharacterStats.Monster.MonsterType = Type
	CharacterStats.HasPlayerChosen = true
	print(CharacterStats.Monster.MonsterType)
	
	# Set confirmation text and make confirmation window appear
	ConfirmationLabel.text = "Are you sure you want to select " + Type + " type?"
	MonsterPickWindow.hide()
	ConfirmationWindow.show()


## Called when user either confirms or denies type
## Closes all windows and continues gameplay
func ConfirmationButton(Answer : String):
	print(Answer)
	
	# Play audio
	Audio.PlaySFX("Click")
	
	
	# Check the users answer
	if Answer == "Yes":
		# Unpause the game
		get_tree().paused = false
		MonsterPickInteractable.queue_free()
		queue_free()
	else:
		ConfirmationWindow.hide()
		MonsterPickWindow.show()


## Called when the user presses the tutorial button
## Gives the player a rundown of each type
func TutorialPressed():
	# Play audio
	Audio.PlaySFX("Click")
	
	MonsterPickWindow.hide()
	ConfirmationWindow.hide()
	TutorialWindow.show()

## Called when the user presses the back button on the tutorial window
## Closes the tutorial window
func TutorialBack() -> void:
	# Play audio
	Audio.PlaySFX("Click")
	
	MonsterPickWindow.show()
	TutorialWindow.hide()
