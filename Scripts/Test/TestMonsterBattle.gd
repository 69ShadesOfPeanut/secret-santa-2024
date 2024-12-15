# Script for testing monster battles
extends Control

# Vars
# Exports
@export_group("Test battle monster stats")
@export_subgroup("Type")
@export_enum("fire", "water", "grass") var PlayerType : String = "fire"
@export_enum("fire", "water", "grass") var EnemyType : String = "grass"
@export_subgroup("Health")
@export var PlayerHealth : int = 20
@export var EnemyHealth : int = 20
@export_subgroup("Attack")
@export var PlayerAttack : int = 8
@export var EnemyAttack : int = 8




# Nodes
@onready var BattleGUI : Control = get_node("BattleGui")

# Monsters
@onready var PlayerMonster : MonsterStats = MonsterStats.new()
@onready var EnemyMonster : MonsterStats = MonsterStats.new()



func _ready() -> void:
	# Setup monster stats
	# Monster type
	PlayerMonster.MonsterType = PlayerType
	EnemyMonster.MonsterType = EnemyType
	# Health
	PlayerMonster.Health = PlayerHealth
	EnemyMonster.Health = EnemyHealth
	# Attack
	PlayerMonster.Attack = PlayerAttack
	EnemyMonster.Attack = EnemyAttack
	# Set player monster to be owned by player
	PlayerMonster.PlayerMonster = true
	PlayerMonster.MonsterName = "Player"
	
	# Start battle
	BattleGUI.SceneSetup(PlayerMonster, EnemyMonster, 0, null)
