# Script for controlling the character
extends CharacterBody2D

# Vars
# Stats
@export var Speed : int = 100


# Gets the keys the player is pressing then turns it into directional velocity
func get_input():
	var InputDirection = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = InputDirection * Speed

# Function that calls get input and handles moving the player
func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
