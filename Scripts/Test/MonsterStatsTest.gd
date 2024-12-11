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
	get_node("Health").text = "Health: " + str(Monster.Health)
	get_node("Attack").text = "Attack: " + str(Monster.Attack)
	get_node("Defence").text = "Defence: " + str(Monster.Defence)
