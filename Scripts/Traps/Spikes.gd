# Script for handling spike traps
extends Node2D

# Vars
# Nodes
@onready var SpikeSprite : Sprite2D = get_node("SpikeSprite")
@onready var WarningSprite : Sprite2D = get_node("WarningSprite")
@onready var WarningTimer : Timer = get_node("WarningSprite/WarningTimer")
# Exports
@export var Damage : int = 10
@export_subgroup("Visible time")
@export var TimeMin : int = 1
@export var TimeMax : int = 15
@export var WarningFlickerRate : float = 0.4


func _ready() -> void:
	SpikeFlicker()

## Do damage to the player when they touch the spikes
func BodyEnteredArea(Body: Node2D) -> void:
	if Body.name == "PlayerCharacter" and SpikeSprite.visible == true:
		Body.TakeDamage(Damage)
		print("Player health is now: " + str(CharacterStats.Health))

## Handles becoming visible and not visible / active and not active
func SpikeFlicker():
	randomize()
	
	
	# Determine a random time and wait before changing visibility
	await get_tree().create_timer(randi_range(TimeMin, TimeMax)).timeout
	
	# Change spike sprite visibility
	SpikeSprite.visible =! SpikeSprite.visible
	
	# Start warning indicator flash if spike invisible
	if SpikeSprite.visible == false:
		#print("Starting warning timer")
		WarningTimer.start(WarningFlickerRate)
	
	SpikeFlicker()

## Handles warning sprite flashing
func WarningFlicker():
	if SpikeSprite.visible == true:
		#print("Spike sprite visible. Stopping function")
		WarningSprite.visible = false
		return
	
	#print("Changing warning sprite visibility")
	WarningSprite.visible =! WarningSprite.visible
	WarningTimer.start(WarningFlickerRate)
