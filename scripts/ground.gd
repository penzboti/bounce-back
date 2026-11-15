extends Node3D

@export var COUNT: int = 1000

var random = RandomNumberGenerator.new()

func get_scene_width(node: Node3D) -> Vector3:
	var aabb = AABB()
	var first = true
	for mesh in node.find_children("*","VisualInstance3D", true, false):
		var mesh_aabb = mesh.get_aabb()
		var transformed_aabb = mesh.global_transform * mesh_aabb
		if first:
			aabb = transformed_aabb
			first = false
		else:
			aabb = aabb.merge(transformed_aabb)
	return aabb.size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random.seed = "fuvet szeretek szivni".length()
	var size = get_scene_width($Plane)
	size = size / 2.0
	for i in COUNT:
		var node = preload("res://blender/grass.blend").instantiate()
		node.set_process_input(false)
		node.scale = Vector3(0.5, 0.5, 0.5)
		node.transform.origin = Vector3(random.randfn(0.0,1.0)*30, 0, random.randfn(0.0,1.0)*size.z)
		get_tree().current_scene.add_child.call_deferred(node)
