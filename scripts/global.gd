extends Node


var health: int = 100
var money: int = 250
var wave: int = 0
var enemies_alive: int = 0


func reset() -> void:
	health = 100
	money = 250
	wave = 0
	enemies_alive = 0
