# Script for controlling the character
extends CharacterBody2D


## Sets the player monster to be owned by the player
func _ready() -> void:
	CharacterStats.Monster.PlayerMonster = true
	CharacterStats.Monster.MonsterName = "Player"

## Gets the keys the player is pressing then turns it into directional velocity
func get_input():
	var InputDirection = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = InputDirection * CharacterStats.Speed

## Function that calls get input and handles moving the player
func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()

## Function called to make the player take damage
func TakeDamage(Damage : int):
	CharacterStats.Health -= Damage
