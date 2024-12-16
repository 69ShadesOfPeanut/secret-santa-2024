# Script for controlling the character
extends CharacterBody2D

# Vars
# Nodes
@onready var MonsterInfoScreen = get_node("%MonsterInfoScreen")

## Sets the player monster to be owned by the player
func _ready() -> void:
	CharacterStats.Monster.PlayerMonster = true
	CharacterStats.Monster.MonsterName = "Player"

## Gets the keys the player is pressing then turns it into directional velocity
func get_input():
	# Get if player is pressing is interaction key
	# Open monster info if key is pressed
	if Input.is_action_just_pressed("MonsterInfo"):
		MonsterInfoScreen.visible = true
		MonsterInfoScreen.get_node("Camera2D").enabled = true
		MonsterInfoScreen.get_node("Camera2D").make_current()
		MonsterInfoScreen.UpdateStats()
		process_mode = PROCESS_MODE_DISABLED
	
	# Move character
	var InputDirection = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = InputDirection * CharacterStats.Speed

## Function that calls get input and handles moving the player
func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()

## Function called to make the player take damage
func TakeDamage(Damage : int):
	CharacterStats.Health -= Damage
