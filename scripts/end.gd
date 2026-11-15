extends Node3D

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random.seed = "halacskaaaaaa".length()
	pass # Replace with function body.


var timer = 0.0
func _process(delta: float) -> void:
	timer += delta
	if timer > 0.2:
		var node = preload("res://scenes/player.tscn").instantiate()
		node.set_process_input(false)
		node.transform.origin = Vector3(random.randfn(0.0,1.0), 10, 0)
		get_tree().current_scene.add_child.call_deferred(node)
		timer -= 0.2


	for child in get_tree().current_scene.get_children():
		if child.has_meta("player"):
			if child.is_on_floor():
				child.velocity.y = child.JUMP_VELOCITY


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
