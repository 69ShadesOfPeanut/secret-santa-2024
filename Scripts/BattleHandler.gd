# Script for handling battles
extends Control

# Vars
var PlayerMonster : MonsterStats
var EnemyMonster : MonsterStats
var ActivePlayerTurn : bool = true
var GameOver : bool = false
var TypeWeakness : Dictionary = {
	"fire": "water",
	"water": "grass",
	"grass": "fire"
}
var TurnNumber : int = 0
# Nodes
@onready var YourHealth : Label = get_node("%YourHealth")
@onready var EnemyHealth : Label = get_node("%EnemyHealth")
@onready var DefendedPlayer : Label = get_node("%DefendedPlayer")
@onready var DefendedEnemy : Label = get_node("%DefendedEnemy")


## Function that prepares scene for battle
func SceneSetup(PMonster : MonsterStats, EMonster : MonsterStats):
	PlayerMonster = PMonster
	EnemyMonster = EMonster
	
	await UpdateStats()

## Function that updates stats on screen
func UpdateStats():
	YourHealth.text = "Your monster health: " + str(PlayerMonster.Health)
	EnemyHealth.text = "Enemy monster health: " + str(EnemyMonster.Health)
	
	# Check health for win condition
	if PlayerMonster.Health <= 0:
		print_rich("[b]ENEMY WINS![/b]")
		PlayerMonster.Health = 0
		YourHealth.text = "Your monster health: " + str(PlayerMonster.Health)
		GameOver = true
	if EnemyMonster.Health <= 0:
		print_rich("[b]Player WINS![/b]")
		EnemyMonster.Health = 0
		EnemyHealth.text = "Enemy monster health: " + str(EnemyMonster.Health)
		GameOver = true




## Function to handle player turn
func PlayerTurn(Action : String):
	# Check if game is over
	if GameOver == true:
		DisableButtons()
		return
	
	TurnNumber += 1
	print_rich("[b]PLAYER TURN #" + str(TurnNumber) + "[/b]")
	print("Player does: " + Action)
	
	# Run function based off of what butotn player presses
	match Action:
		"Attack":
			Attack(PlayerMonster, EnemyMonster)
		"Type attack":
			TypeAttack(PlayerMonster, EnemyMonster)
		"Defend":
			Defend(PlayerMonster, EnemyMonster)
	
	# Check if enemy is defended
	# If enemy is defended, disable defence
	if EnemyMonster.Defended == true:
		EnemyMonster.Defended = false
		DefendedEnemy.hide()
		print("Enemy monster defence now disabled")
	
	# Make it the enemy turn
	EnemyTurn()

## Function for handling the enemy turn
## for now it just selects a random option
func EnemyTurn():
	# Check if game is over
	if GameOver == true:
		DisableButtons()
		return
	
	DisableButtons()
	print_rich("[b]ENEMY TURN #" + str(TurnNumber) + "[/b]")
	
	# Wait before making turn (so it doesn't instantly pass)
	await get_tree().create_timer(2.5).timeout
	
	# Pick a random option
	randomize()
	var RandomOption = randi_range(1, 3)
	match RandomOption:
		1:
			Attack(EnemyMonster, PlayerMonster)
		2:
			TypeAttack(EnemyMonster, PlayerMonster)
		3:
			Defend(EnemyMonster, PlayerMonster)
	
	# Check if player is defended
	# If player is defended, disable defence
	if PlayerMonster.Defended == true:
		PlayerMonster.Defended = false
		DefendedPlayer.hide()
		print("Player monster defence now disabled")
	
	DisableButtons()

## Disable or enable buttons depending on turn
func DisableButtons():
	for B : Button in get_node("%Actions").get_children():
		B.disabled =! B.disabled


## Function to attacking
func Attack(AttackingMonster : MonsterStats, DefendingMonster : MonsterStats) -> void:
	print("Attack action")
	# Checks if the defending enemy defended
	if DefendingMonster.Defended == true:
		print("Defending monster is defended")
		DefendingMonster.Health -= (AttackingMonster.Attack / 1.5)
		DefendingMonster.Defended = false
		
		# Hide defending monster defended GUI element
		if DefendingMonster.PlayerMonster == true:
			DefendedPlayer.hide()
		else:
			DefendedEnemy.hide()
	else:
		print("Defending monster is not defended")
		DefendingMonster.Health -= AttackingMonster.Attack
	
	print("Defending monster health is now: " + str(DefendingMonster.Health))
	UpdateStats()

## Function to type attacking
func TypeAttack(AttackingMonster : MonsterStats, DefendingMonster : MonsterStats) -> void:
	print("Type attack action")
	print("Defending monster is weak to: " + TypeWeakness[DefendingMonster.MonsterType])
	# Check if defending monster is weak to attacking
	# if weak, do 1.5 damage. if not weak, do regular damage
	# Also check if defending monster is defended
	if AttackingMonster.MonsterType == TypeWeakness[DefendingMonster.MonsterType]:
		print("Type attack success!")
		if DefendingMonster.Defended == true:
			print("Defending monster is defended!\nDoing regular damage")
			Attack(AttackingMonster, DefendingMonster)
			return
		DefendingMonster.Health -= (AttackingMonster.Attack * 1.5)
	else:
		print("Type attack fail!\nResorting to regular attack")
		Attack(AttackingMonster, DefendingMonster)
		return
	
	print("Defending monster health is now: " + str(DefendingMonster.Health))
	UpdateStats()

## Function to defend
func Defend(AttackingMonster : MonsterStats, DefendingMonster : MonsterStats):
	print("Defend action")
	AttackingMonster.Defended = true
	print("Defending monster defense state: " + str(AttackingMonster.Defended))
	
	# Show the defended GUI element
	if AttackingMonster.PlayerMonster == true:
		DefendedPlayer.show()
	else:
		DefendedEnemy.show()
