@tool
class_name Object_4
extends StaticBody3D

func _ready():

	# =========================
	# ПОЛ
	# =========================

	var mesh_instance := MeshInstance3D.new()

	var plane := BoxMesh.new()

	plane.size = Vector3(40, 1, 40)

	mesh_instance.mesh = plane

	# =========================
	# МАТЕРИАЛ
	# =========================

	var mat := StandardMaterial3D.new()

	# Не зеркало
	mat.metallic = 0.0

	# Мягкий красивый матовый пол
	mat.roughness = 0.65

	# Красивый мягкий свет
	mat.specular = 0.35

	# Слегка серый
	mat.albedo_color = Color(0.82, 0.82, 0.84)

	# Очень важно
	mat.subsurf_scatter_enabled = true
	mat.subsurf_scatter_strength = 0.05

	# Чуть мягче края света
	mat.rim_enabled = true
	mat.rim = 0.02

	mesh_instance.material_override = mat

	add_child(mesh_instance)

	# =========================
	# КОЛЛИЗИЯ
	# =========================

	var collision := CollisionShape3D.new()

	var shape := BoxShape3D.new()
	shape.size = Vector3(40, 1, 40)

	collision.shape = shape

	add_child(collision)
