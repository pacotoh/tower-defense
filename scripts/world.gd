extends Node3D

@onready var enemy: PackedScene = preload("res://scenes/enemy.tscn")
@onready var cannon: PackedScene = preload("res://scenes/cannon.tscn")
@onready var cam: Camera3D = $Camera3D
@onready var indicator: MeshInstance3D = $Indicator
@export var env_color: Color

@onready var green_indicator: Material = load("res://assets/materials/green.tres")
@onready var red_indicator: Material = load("res://assets/materials/red.tres")

var enemies_to_spawn: int = 0
var can_spawn: bool = false
var in_build_menu: bool = false
var wave_on_going: bool = false


func _process(_delta: float):
	$WorldEnvironment.environment.background_color = env_color
	handle_player_controls()
	game_manager()
	handle_ui()


func handle_player_controls() -> void:
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	
	# raycast creation
	var origin: Vector3 = cam.project_ray_origin(mouse_pos)
	var end: Vector3 = origin + cam.project_ray_normal(mouse_pos) * 100
	var raycast: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
	raycast.collide_with_bodies = true
	
	var ray_result: Dictionary = space_state.intersect_ray(raycast)
	
	if not in_build_menu:
		if ray_result.size() > 0:
			indicator.visible = true
			var collider: CollisionObject3D = ray_result.get("collider")
			indicator.global_position = collider.global_position + Vector3(0, 0.2, 0)
			if collider.is_in_group("Empty"):
				indicator.set_surface_override_material(0, green_indicator)
				if Input.is_action_just_pressed("left_click"):
					in_build_menu = true
			else:
				indicator.set_surface_override_material(0, red_indicator)
		else:
			indicator.visible = false


func game_manager() -> void:
	if Global.health <= 0:
		game_over()
	
	if enemies_to_spawn > 0 and can_spawn:
		$SpawnTimer.start()
		var temp_enemy = enemy.instantiate()
		$Path.add_child(temp_enemy)
		enemies_to_spawn -= 1
		Global.enemies_alive += 1
		can_spawn = false
		
	wave_on_going = Global.enemies_alive > 0


func handle_ui() -> void:
	$TowerRoundSampleF/HealthBar3D.update(Global.health)
	$CanvasLayer/UI/ShopPanel.visible = in_build_menu
	$CanvasLayer/UI/NextWaveButton.visible = not wave_on_going
	$CanvasLayer/UI/Gold.text = "Gold: " + str(Global.money)
	$CanvasLayer/UI/Wave.text = "Wave: " + str(Global.wave)


func game_over() -> void:
	$CanvasLayer/UI/GameOverPanel.visible = true


func _on_spawn_timer_timeout():
	can_spawn = true


func buy_tower(cost: int, scene: PackedScene) -> void:
	if Global.money >= cost:
		in_build_menu = false
		Global.money -= cost
		var temp_cannon: StaticBody3D = scene.instantiate()
		add_child(temp_cannon)
		temp_cannon.global_position = indicator.global_position


func _on_cannon_button_pressed():
	buy_tower(250, cannon)


func _on_cancel_button_pressed():
	in_build_menu = false


func _on_next_wave_button_pressed():
	Global.wave += 1
	enemies_to_spawn = Global.wave * 3
	can_spawn = true


func _on_play_again_button_pressed():
	Global.reset()
	get_tree().reload_current_scene()


func _on_quit_button_pressed():
	get_tree().quit()
