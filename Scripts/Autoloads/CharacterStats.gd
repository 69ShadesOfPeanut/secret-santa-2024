# Autoload script for handling player stats
extends Node


# Stats
var Speed : int = 100
var Health : int = 100

var Monster = MonsterStats.new()
var TrainersDefeated : int = 0
var HasPlayerChosen : bool = false

var Score : int = 0
