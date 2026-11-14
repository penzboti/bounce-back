extends Node3D

@export var length: int = 0

@onready var tree: Node3D = $tree
@onready var tree_scn = preload("res://blender/tree.blend")

@onready var collision = $StaticBody3D

@export_enum("+x","-x","+z","-z","+y","-y") var direction: String

func get_scene_width(node: Node3D) -> float:
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
	var width = aabb.size.x
	return width

func get_direction() -> Dictionary:
	var dir: String = ""
	var mirror: int = 0
	if direction == "+x" or direction == "-x":
		dir = "x"
	if direction == "+y" or direction == "-y":
		dir = "y"
	if direction == "+z" or direction == "-z":
		dir = "z"
	if direction == "+z" or direction == "+x" or direction == "+y":
		mirror = 1
	else:
		mirror = -1
	if dir == "":
		print("no direction found!")

	return {"dir": dir, "mirror": mirror}

func _ready() -> void:
	var dir = get_direction()

	var width = get_scene_width(tree)

	var count = ceili(float(length) / width)

	# some vibe coding was used here

	for i in range(1, count):
		var scn = tree_scn.instantiate()
		add_child(scn)

		scn.transform = tree.transform
		scn.position[dir.dir] += dir.mirror * width * i

	var total_width = count * width

	var shape_node: CollisionShape3D = $StaticBody3D/CollisionShape3D
	var shape = shape_node.shape.duplicate() as BoxShape3D
	shape_node.shape = shape

	shape.size[dir.dir] = total_width-width/2.0

	$StaticBody3D.position[dir.dir] = dir.mirror * (total_width - width) / 2.0
