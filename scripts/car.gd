extends Node3D

var speed: float

var start_position: Vector3
var max_distance: float
var flip: int = 1

var on_car: bool = false
@onready var area = $Area3D
@onready var player = get_tree().current_scene.get_node("player")

func _ready() -> void:
	pass

func start_moving(distance: float, _speed: float):
	start_position = global_position
	if distance < 0:
		flip = -1
		distance = distance*flip
	max_distance = distance
	speed = _speed

func _process(delta):
	global_position += global_transform.basis.z * speed * delta

	var distance_traveled = start_position.distance_to(global_position)

	if distance_traveled >= max_distance:
		queue_free()

	if on_car and player.is_on_floor():
		player.global_position += flip*global_transform.basis.z * speed * delta


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_meta("player"):
		on_car = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.has_meta("player"):
		on_car = false
