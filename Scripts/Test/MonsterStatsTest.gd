# Test script for testing the monster resource
extends VBoxContainer


# Vars
@export var Monster : MonsterStats
const LevelUpGUI = preload("res://Scenes/LevelUp.tscn")



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
	var LevelUp = Monster.AddXP(100)
	
	if LevelUp == true:
		var LevelUpGUIInstance : Window = LevelUpGUI.instantiate()
		get_parent().add_child(LevelUpGUIInstance)
		LevelUpGUIInstance.move_to_center()
		LevelUpGUIInstance.SetUp(Monster)
	
	# Update GUI
	_ready()
