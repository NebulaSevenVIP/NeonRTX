@tool
class_name Object_1
extends RigidBody3D


func _ready():
	var mesh = MeshInstance3D.new()
	var collision = CollisionShape3D.new()

	var sphere := SphereMesh.new()
	sphere.radius = 1.0
	sphere.height = 2.0

	mesh.mesh = sphere

	mesh.add_uv2 = true

	var material := StandardMaterial3D.new()

	material.metallic = 1.0

	material.roughness = 0.03

	material.clearcoat_enabled = true
	material.clearcoat = 1.0

	material.albedo_color = Color(0.9, 0.9, 0.95)

	mesh.material_override = material

	add_child(mesh)

	collision = CollisionShape3D.new()

	var shape := SphereShape3D.new()
	shape.radius = 1.0

	collision.shape = shape

	add_child(collision)
