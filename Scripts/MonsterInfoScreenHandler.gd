# Script that handles the monster info screen
extends Control

# Vars
# Nodes
@onready var TypeLabel : Label = get_node("%Type")
@onready var HealthLabel : Label = get_node("%Health")
@onready var AttackLabel : Label = get_node("%Attack")
@onready var PlayerCharacter : CharacterBody2D = get_node("%PlayerCharacter")
@onready var XPLabel : Label = get_node("%XP")
@onready var XPBar : ProgressBar = get_node("%XPBar")



func _ready() -> void:
	UpdateStats()

# Function to set the labels
func UpdateStats() -> void:
	TypeLabel.text = "Type: " + CharacterStats.Monster.MonsterType
	HealthLabel.text = "Health: " + str(CharacterStats.Monster.Health) + "/" + str(CharacterStats.Monster.MaxHealth)
	AttackLabel.text = "Attack: " + str(CharacterStats.Monster.Attack)
	XPLabel.text = "XP: " + str(CharacterStats.Monster.Experience)
	XPBar.max_value = CharacterStats.Monster.ExperienceLevelUp
	XPBar.value = CharacterStats.Monster.Experience

# Exits the menu
func BackButton() -> void:
	PlayerCharacter.process_mode = PROCESS_MODE_INHERIT
	get_node("Camera2D").enabled = false
	hide()
