# Script to handle interacable nodes in this game
extends Area2D
class_name Interactable

# Vars
var InRange = true
const SignResource = preload("res://Scenes/Sign.tscn")
@onready var BattleGUI : Control = get_node("%BattleGui")
@onready var PlayerCharacter : CharacterBody2D = get_node("%PlayerCharacter")
# Export vars
@export var InteractText : String = "interact"
@export_subgroup("Level Transfer")
## Toggle to set if this interactable will transfer the player to another scene
@export var LevelTransfer : bool
## The level this will transfer the player to
@export_file var Level
## Toggle to set if the interactable should check the state of something first
@export var CheckState : bool
## Leave toggle off if it should be bool. Turn on if you want int check
@export var CheckInt : bool
## The value to check. It'll ALWAYS check if the value if higher than
@export var CheckIntValue : int
## The name of the value that the interactable should check
@export var ValueToCheck : String
@export_subgroup("Scene instance")
## Toggle to set if this interactable will instance a scene
@export var SceneInstance : bool
## The location of the scene to instance
@export var SceneFile : Resource
@export_subgroup("Sign")
## Toggle to set if this interactable will be a sign and purely display text
@export var Sign : bool
## Text to display on the sign
@export_multiline var SignText : String
@export_subgroup("Trainer")
## Toggle to set if this interactable will be a trainer battle
@export var Trainer : bool
## The monster the trainer will use
@export var TrainerMonster : MonsterStats
## If the trainer should have a random monster type
@export var RandomMonsterType : bool
# The amount of XP to give
@export var XPGiven : int


# Function called when a Node2D enters the area
func BodyEntered(Body: Node2D) -> void:
	if Body.name == "PlayerCharacter":
		InRange = true
		print("Player entered area")
		Body.get_node("CharacterLabel").text = "Press F to " + InteractText
		Body.get_node("CharacterLabel").show()
		
		
		# Check what interactable needs to do
		while InRange == true:
			await get_tree().process_frame
			if Input.is_action_just_pressed("Interact"):
				print("Player interaction")
				# Check what action needs to be done
				if LevelTransfer == true:
					# Check if the interactable needs to check a status
					if CheckState == true:
						# Check what type of check state it needs to be
						if CheckInt == false:
							if CharacterStats[ValueToCheck] == false:
								print("Player doesn't meet bool check requirements. Returning.")
								return
						else:
							if CharacterStats[ValueToCheck] < CheckIntValue:
								print("Player doesn't meet int check requirements. Returning.")
								return
					
					# Attempt to change the level
					print("Changing levels...")
					var Result = get_tree().change_scene_to_file(Level)
					if Result != OK:
						printerr("Scene load failed")
					else:
						print("Scene load success!")
				elif SceneInstance == true:
					var SceneInstance = SceneFile.instantiate()
					add_child(SceneInstance)
					get_tree().paused = true
				elif Sign == true:
					var SignInstance = SignResource.instantiate()
					SignInstance.get_node("%Label").text = SignText
					add_child(SignInstance)
					get_tree().paused = true
				elif Trainer == true:
					# Checks if random monster type is turned on, then assign a random type
					if RandomMonsterType == true:
						var TypeNum = randi_range(1, 3)
						match TypeNum:
							1:
								TrainerMonster.MonsterType = "fire"
							2:
								TrainerMonster.MonsterType = "water"
							3:
								TrainerMonster.MonsterType = "grass"
						print("Trainer monster type is " + TrainerMonster.MonsterType)
					
					# Setup the battle GUI
					BattleGUI.get_node("Camera2D").enabled = true
					BattleGUI.get_node("Camera2D").make_current()
					BattleGUI.show()
					PlayerCharacter.process_mode = PROCESS_MODE_DISABLED
					
					BattleGUI.SceneSetup(CharacterStats.Monster, TrainerMonster, XPGiven, self)
				InRange = false


# Function called when a Node2D exits the area
func BodyExited(Body: Node2D) -> void:
	if Body.name == "PlayerCharacter":
		InRange = false
		print("Player exited area")
		Body.get_node("CharacterLabel").hide()
