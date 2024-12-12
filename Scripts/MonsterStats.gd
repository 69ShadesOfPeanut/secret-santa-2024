# Script that creates a monster stas resource
# Also handles functions related to monster stats
extends Resource
class_name MonsterStats

# Extras
# If the pokemon will be defended next time its attacked
var Defended = false

# Base stats
@export_group("Base stats")
# The level of the monster
var Level : int = 1
# The current experience
var Experience : int = 0
# The current experience needed to level up
var ExperienceLevelUp : int = 100
# How many unspent skill points monster has
var SkillPoints : int = 0

# Monster type
@export_enum("fire", "water", "grass") var MonsterType : String = "fire"

# Stats
@export var Health : int = 20
@export var Attack : int = 8

# Stats for if randomise stats is on
@export_group("RandomStats")
## Toggle on to have starting stats be random
@export var RandomiseStats : bool = false
@export_subgroup("Health Range")
@export_range(1, 20) var MinHealth : int
@export_range(1, 20) var MaxHealth : int
@export_subgroup("Attack Range")
@export_range(1, 20) var MinAttack : int
@export_range(1, 20) var MaxAttack : int


# Randomise stats if randomise stat is turned on
func RandomiseStatsFunction():
	print("Randomise stats function called")
	
	Health = randi_range(MinHealth, MaxHealth)
	Attack = randi_range(MinAttack, MaxAttack)

# Function that adds experience
func AddXP(XPGiven : int):
	Experience += XPGiven
	print("Current experience is: " + str(Experience))
	
	# Checks if current XP is enough to level up
	# resets XP back to 0 if so
	if Experience >= ExperienceLevelUp:
		print("Level up!")
		Level += 1
		SkillPoints += Level / 2
		ExperienceLevelUp += 100
		Experience = 0
		print("Current level is: " + str(Level) + "\nCurrent experience to level up is: " + str(ExperienceLevelUp))
		
		return true
	return false
