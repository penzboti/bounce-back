extends Camera3D

@onready var player = get_tree().current_scene.get_node("player")

const CAMERA_SPEED = 0.1

var base_z
func _ready() -> void:
	base_z = self.transform.origin.z

func _process(_delta: float) -> void:
	# self.transform.origin.z = move_toward(self.transform.origin.z, player.transform.origin.z + base_z, CAMERA_SPEED)
	self.transform.origin.z = player.transform.origin.z # debug
	pass
