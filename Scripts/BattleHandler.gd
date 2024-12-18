# Script for handling battles
extends Control

# Vars
const LevelUpGUI = preload("res://Scenes/LevelUp.tscn")
var PlayerMonster : MonsterStats
var EnemyMonster : MonsterStats
var ActivePlayerTurn : bool = true
var GameOver : bool = false
var XPAwarded : int = 0
var ScoreGiven : int = 0
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
@onready var PlayerCharacter : CharacterBody2D = get_node("%PlayerCharacter")
@onready var BattleLog : RichTextLabel = get_node("%BattleLog")
var TrainerNode : Interactable


## Function that prepares scene for battle
func SceneSetup(PMonster : MonsterStats, EMonster : MonsterStats, Experience : int, Trainer : Interactable, Score : int):
	PlayerMonster = PMonster
	EnemyMonster = EMonster
	XPAwarded = Experience
	TrainerNode = Trainer
	ScoreGiven = Score
	
	BattleLog.clear()
	
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
		
		# Change to game over scene
		get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
	if EnemyMonster.Health <= 0:
		print_rich("[b]Player WINS![/b]")
		EnemyMonster.Health = 0
		EnemyHealth.text = "Enemy monster health: " + str(EnemyMonster.Health)
		GameOver = true
		
		# Award XP and hide BattleGUI
		if get_parent().name == "TestMonsterBattle":
			return
		
		# Add experience and check if level up is required
		var LevelUp = PlayerMonster.AddXP(XPAwarded)
		if LevelUp == true:
			var LevelUpGUIInstance : Window = LevelUpGUI.instantiate()
			add_child(LevelUpGUIInstance)
			LevelUpGUIInstance.move_to_center()
			LevelUpGUIInstance.SetUp(PlayerMonster)
		
		# Give player character +1 trainer defeat
		CharacterStats.TrainersDefeated += 1
		print("Player has now defeated " + str(CharacterStats.TrainersDefeated) + " trainers")
		
		# Give player awarded score
		CharacterStats.Score += ScoreGiven
		print("Player now has " + str(CharacterStats.Score) + " score!")
		
		# Heal the player
		CharacterStats.Monster.Health = CharacterStats.Monster.MaxHealth
		
		# Unpause character and resume camera control
		PlayerCharacter.process_mode = PROCESS_MODE_INHERIT
		get_node("Camera2D").enabled = false
		hide()
		
		# Checks if theres a trainer node
		# If there is one, then free the trainer node so that you can't rechallenge
		if TrainerNode == null:
			return
		TrainerNode.queue_free()




## Function to handle player turn
func PlayerTurn(Action : String):
	# Check if game is over
	if GameOver == true:
		DisableButtons()
		return
	
	TurnNumber += 1
	print_rich("[b]PLAYER TURN #" + str(TurnNumber) + "[/b]")
	BattleLog.append_text("[b]PLAYER TURN #" + str(TurnNumber) + "[/b]\n")
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
	# Play audio
	Audio.PlaySFX("Click")
	
	# Check if game is over
	if GameOver == true:
		DisableButtons()
		return
	
	DisableButtons()
	print_rich("[b]ENEMY TURN #" + str(TurnNumber) + "[/b]")
	BattleLog.append_text("[b]ENEMY TURN #" + str(TurnNumber) + "[/b]\n")
	
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
		BattleLog.append_text(AttackingMonster.MonsterName + " hits " + DefendingMonster.MonsterName + " but was defended. Dealt " + str(AttackingMonster.Attack / 1.5) + "\n")
		DefendingMonster.Defended = false
		
		# Hide defending monster defended GUI element
		if DefendingMonster.PlayerMonster == true:
			DefendedPlayer.hide()
		else:
			DefendedEnemy.hide()
	else:
		print("Defending monster is not defended")
		DefendingMonster.Health -= AttackingMonster.Attack
		
		# Log damage
		BattleLog.append_text(AttackingMonster.MonsterName + " hits " + DefendingMonster.MonsterName + " for " + str(AttackingMonster.Attack) + "\n")
	
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
		BattleLog.append_text(AttackingMonster.MonsterName + " hits " + DefendingMonster.MonsterName + " and was effective! Dealing " + str(AttackingMonster.Attack * 1.5) + "\n")
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
	BattleLog.append_text(AttackingMonster.MonsterName + " will be defended next time they are attacked\n")
	
	# Show the defended GUI element
	if AttackingMonster.PlayerMonster == true:
		DefendedPlayer.show()
	else:
		DefendedEnemy.show()
