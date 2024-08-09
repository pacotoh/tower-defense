extends Sprite3D

@onready var bar: ProgressBar = $SubViewport/HealthBar2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = $SubViewport.get_texture()


func setup(value: int) -> void:
	bar.setup_bar(value)
	

func update(value: int) -> void:
	bar.update_bar(value)
