# Script to handle the game over menu
extends Control

# Vars
@export var MaxUsernameLength : int = 20
# Nodes
@onready var UsernameEnterNode : LineEdit = get_node("%UsernameEnter")


# Function called when username gets entered in and user presses enter
func UsernameEnter() -> void:
	var UsernameWithoutSpaces = UsernameEnterNode.text.lstrip(" ")
	# Check if username is too long
	if UsernameEnterNode.text.length() >= MaxUsernameLength or UsernameWithoutSpaces.is_empty():
		print("Username too long or short")
		UsernameEnterNode.clear()
		UsernameEnterNode.placeholder_text = "Username too long or short"
		return
	
	# Post score and change scene
	await Leaderboards.post_guest_score("secret-santa-2024-secret-santa-20-jrSf", CharacterStats.TrainersDefeated, UsernameEnterNode.text)
	get_tree().change_scene_to_file("res://addons/quiver_leaderboards/leaderboard_ui.tscn")
