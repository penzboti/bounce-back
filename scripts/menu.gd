extends Node3D

@export var load_scene: PackedScene

func _ready() -> void:
	for child in get_tree().current_scene.get_children():
		if child.has_meta("player"):
			child.set_process_input(false)


func _process(_delta: float) -> void:
	for child in get_tree().current_scene.get_children():
		if child.has_meta("player"):
			if child.is_on_floor():
				child.velocity.y = child.JUMP_VELOCITY
				if child.in_trampoline:
					child.velocity.y *= 3


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(load_scene)
