extends Node3D

@onready var enemy: PackedScene = preload("res://scenes/enemy.tscn")
var enemies_to_spawn: int = 3
var can_spawn: bool = true



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	game_manager()
	

func game_manager() -> void:
	if enemies_to_spawn > 0 and can_spawn:
		$SpawnTimer.start()
		var temp_enemy = enemy.instantiate()
		$Path.add_child(temp_enemy)
		enemies_to_spawn -= 1
		can_spawn = false


func _on_spawn_timer_timeout():
	can_spawn = true
