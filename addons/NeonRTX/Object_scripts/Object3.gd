@tool
class_name Object_3
extends RigidBody3D

func _ready():

	# MeshInstance
	var mesh_instance := MeshInstance3D.new()

	# Создаём SphereMesh
	var sphere := SphereMesh.new()

	sphere.radius = 1.0
	sphere.height = 2.0

	# МНОГО полигонов
	sphere.radial_segments = 128
	sphere.rings = 64

	# Присваиваем mesh
	mesh_instance.mesh = sphere

	# Материал
	var mat := StandardMaterial3D.new()

	# НЕ металл
	mat.metallic = 0.0

	mat.add_uv2 = true
	# Почти матовый
	mat.roughness = 0.75

	# Мягкий блик
	mat.specular = 0.4

	# Очень красивый мягкий свет
	mat.subsurf_scatter_enabled = true
	mat.subsurf_scatter_strength = 0.15

	# Цвет
	mat.albedo_color = Color(0.93, 0.93, 0.93)

	# Rim light
	mat.rim_enabled = true
	mat.rim = 0.05

	# Материал на mesh
	mesh_instance.material_override = mat

	# Добавляем в сцену
	add_child(mesh_instance)

	# Коллизия
	var collision := CollisionShape3D.new()

	var shape := SphereShape3D.new()
	shape.radius = 1.0

	collision.shape = shape

	add_child(collision)
