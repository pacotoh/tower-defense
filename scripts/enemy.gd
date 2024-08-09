extends CharacterBody3D

@export var speed: int = 2
@export var health: int = 15
@onready var path: PathFollow3D = get_parent()


func _physics_process(delta: float):
	path.set_progress(path.get_progress() + speed * delta)
	if path.get_progress_ratio() >= 0.99:
		Global.health -= 20
		death()
		

func take_damage(damage: int) -> void:
	health -= damage
	
	if health <= 0:
		Global.money += 50
		death()


func death() -> void:
	Global.enemies_alive -= 1
	path.queue_free()
