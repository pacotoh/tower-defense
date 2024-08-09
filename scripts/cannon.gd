extends StaticBody3D

var bullet = preload("res://scenes/bullet.tscn")
var bullet_damage: int = 5
var current_targets: Array = []
var current: CharacterBody3D
var can_shoot: bool = true
const SMOOTH_SPEED: float = .05


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if is_instance_valid(current):
		look_at(current.global_position)
		if can_shoot:
			shoot()
			can_shoot = false
			$ShootingCooldown.start()
	else:
		for i in get_node("BulletContainer").get_child_count():
			get_node("BulletContainer").get_child(i).queue_free()


func shoot() -> void:
	var temp_bullet: CharacterBody3D = bullet.instantiate()
	temp_bullet.target = current
	temp_bullet.bullet_damage = bullet_damage
	get_node("BulletContainer").add_child(temp_bullet)
	temp_bullet.global_position = $MeshInstance3D/Aim.global_position

func choose_target(_current_targets: Array) -> void:
	var temp_array: Array = current_targets
	var current_target: CharacterBody3D = null
	for target in temp_array:
		if current_target == null or \
		target.get_parent().get_progress() > current_target.get_parent().get_progress():
			current_target = target
			
	current = current_target

func _on_mob_detector_body_entered(body):
	if body.is_in_group("Enemy"):
		current_targets.append(body)
		choose_target(current_targets)


func _on_mob_detector_body_exited(body):
	if body.is_in_group("Enemy"):
		current_targets.erase(body)
		choose_target(current_targets)


func _on_shooting_cooldown_timeout():
	can_shoot = true
