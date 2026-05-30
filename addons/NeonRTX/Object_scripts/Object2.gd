@tool
class_name Object_2
extends RigidBody3D


func _ready():

	var mesh = MeshInstance3D.new()

	@warning_ignore("unused_variable")
	var collision = CollisionShape3D.new()
	collision.shape = SphereShape3D.new()

	var sphere := SphereMesh.new()
	sphere.radius = 0.25
	sphere.height = 0.5
	mesh.mesh = sphere

	mesh.add_uv2 = true
	

	var material := StandardMaterial3D.new()

	# НЕ зеркало
	material.metallic = 0.0

	# Немного гладкости
	material.roughness = 0.18

	# Красивый мягкий блик
	material.specular = 1.0

	# Случайный пастельный цвет
	material.albedo_color = Color.from_hsv(
		randf(),
		0.35,
		1.0
	)

	mesh.material_override = material

	add_child(mesh)
	add_child(collision)

	# Smooth shading
	sphere.radial_segments = 64
	sphere.rings = 32
