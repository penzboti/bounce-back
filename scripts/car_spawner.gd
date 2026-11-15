extends Node3D

var travel_distance: float = 50.0
var scene_to_copy = preload("res://scenes/car.tscn")

@export var speed: float = 8.0
@export var count: int = 4
# var spawn_time = 1.15
@export var spawn_time: float = 1.0
@export var flip: bool = false

func _ready():
	$car.visible = false
	spawn_copy()
	print()

var time = 0.0
var c = 0
func _process(delta: float):
	if time > spawn_time:
		time -= spawn_time
		c = c+1
		if c % (count+1) != 0:
			spawn_copy()
	time += delta

# might be ai
func spawn_copy():
	var copy = scene_to_copy.instantiate()
	get_tree().current_scene.add_child.call_deferred(copy)

	copy.global_transform = global_transform
	copy.start_moving(travel_distance * (-1 if flip else 1), speed)
