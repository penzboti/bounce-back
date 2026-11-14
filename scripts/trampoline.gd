extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.has_meta("player"):
		body.in_trampoline = true;

func _on_body_exited(body: Node3D) -> void:
	if body.has_meta("player"):
		body.in_trampoline = false;
