# Script to handle interacable nodes in this game
extends Area2D

# Vars
var InRange = true
# Export vars
@export var InteractText : String = "interact"
@export_subgroup("Level Transfer")
## Toggle to set if this interactable will transfer the player to another scene
@export var LevelTransfer : bool
## The level this will transfer the player to
@export_file var Level

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
					print("Changing levels...")
					var Result = get_tree().change_scene_to_file(Level)
					if Result != OK:
						printerr("Scene load failed")
					else:
						print("Scene load success!")
				InRange = false

# Function called when a Node2D exits the area
func BodyExited(Body: Node2D) -> void:
	if Body.name == "PlayerCharacter":
		InRange = false
		print("Player exited area")
		Body.get_node("CharacterLabel").hide()
