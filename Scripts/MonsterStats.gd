# Script that creates a monster stas resource
# Also handles functions related to monster stats
extends Resource
class_name MonsterStats


# Base stats
@export_group("Base stats")
@export var Health : int
@export var Attack : int
@export var Defence : int

# Stats for if randomise stats is on
@export_group("RandomStats")
@export var RandomiseStats : bool = false
@export_subgroup("Health Range")
@export var MinHealth : int
@export var MaxHealth : int
@export_subgroup("Attack Range")
@export var MinAttack : int
@export var MaxAttack : int
@export_subgroup("Defence Range")
@export var MinDefence : int
@export var MaxDefence : int


# Randomise stats if randomise stat is turned on
func RandomiseStatsFunction():
	print("Randomise stats function called")
	
	Health = randi_range(MinHealth, MaxHealth)
	Attack = randi_range(MinAttack, MaxAttack)
	Defence = randi_range(MinDefence, MaxDefence)
