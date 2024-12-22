# Script that handles the Level Up GUI
extends Window

# Vars
var PlayerMonster : MonsterStats
# Nodes
@onready var LevelUpLabel : Label = get_node("VBoxContainer/LevelUpLabel")


## Display how many skill points player monster has to spend
func SetUp(PMonster : MonsterStats):
	PlayerMonster = PMonster
	UpdateText()

## Function to update text on screen
func UpdateText():
	LevelUpLabel.text = "You have just leveled up!
	You have " + str(PlayerMonster.SkillPoints) + " unspent skill points"


## Function called when a button is pressed
func ButtonPress(ButtonStat : String):
	print(ButtonStat + " button pressed")
	
	# Play audio
	Audio.PlaySFX("Click")
	
	
	# Check stat then increase it
	match  ButtonStat:
		"Health":
			var RandomHealthUpgrade = randi_range(1, 5)
			
			PlayerMonster.MaxHealth += RandomHealthUpgrade
			print("Player health is now: " + str(PlayerMonster.Health))
			
			# Heal the player
			CharacterStats.Monster.Health = CharacterStats.Monster.MaxHealth
		"Attack":
			var RandomAttackUpgrade = randi_range(1, 5)
			
			PlayerMonster.Attack += RandomAttackUpgrade
			print("Player attack is now: " + str(PlayerMonster.Attack))
	PlayerMonster.SkillPoints -= 1
	
	# Stop player from once they reach 0 skill points
	if PlayerMonster.SkillPoints <= 0:
		print("All skill points used")
		queue_free()
		return
	
	UpdateText()
