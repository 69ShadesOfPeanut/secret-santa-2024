# Test script for testing the monster resource
extends VBoxContainer


# Vars
@export var Monster : MonsterStats



func _ready() -> void:
	if Monster.RandomiseStats == true:
		Monster.RandomiseStatsFunction()
	
	SetText()

# Func to set the test text to the monster stats
func SetText() -> void:
	get_node("Level").text = "Level: " + str(Monster.Level)
	get_node("Experience").text = "Experience: " + str(Monster.Experience)
	get_node("ExperienceToLevel").text = "Experience To Level: " + str(Monster.ExperienceLevelUp)
	get_node("Health").text = "Health: " + str(Monster.Health)
	get_node("Attack").text = "Attack: " + str(Monster.Attack)

# Func to level up the test monster
func LevelUpTest() -> void:
	Monster.AddXP(100)
	_ready()
