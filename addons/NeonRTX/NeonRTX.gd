@tool
@icon("icon.png")
extends Node3D

@export var settings : RTXSettings = RTXSettings.new()


var env_default : WorldEnvironment
var directlight_default : DirectionalLight3D
var grafics
var directional_light
var world_environment
var baked_scene : LightmapGI
@onready var env := preload(
	"Material/rtx_environment.tres"
).duplicate(true)
func _ready() -> void:
	NeonRTX.ray_tracer.setup(
		get_viewport()
	)
	NeonRTX.path_tracer.setup(
		NeonRTX.ray_tracer
	)
	Engine.max_fps = 0
	_find_existing_nodes()
	_apply_state()
func _find_existing_nodes() -> void:
	for child in get_children():
		if child is LightmapGI:
			baked_scene = child
			break
func _create_lightmap_gi() -> void:
	if baked_scene != null:
		return
	for child in get_children():
		if child is LightmapGI:
			baked_scene = child
			return
	baked_scene = LightmapGI.new()
	baked_scene.bounces = 16
	baked_scene.quality = LightmapGI.BAKE_QUALITY_ULTRA
	baked_scene.directional = true
	baked_scene.bias = 0.001
	baked_scene.name = "LightmapGI"
	baked_scene.owner = get_tree().edited_scene_root
	var script = load(
		"res://addons/NeonRTX/Object_scripts/lightmap_scene.gd"
	)
	if script:
		baked_scene.set_script(script)
func _bake_lightmap() -> void:
	_create_lightmap_gi()
	if baked_scene == null:
		push_error(
			"LIGHTMAP GI NOT FOUND"
		)
		return
	baked_scene.call_deferred(
		"bake",
		NodePath("..")
	)
func _process(delta: float) -> void:
	_apply_state()
	_apply_default_state()
	_update_environment()
	_update_graphics()
	default_set(
		settings.default_enabled
	)
func _apply_state() -> void:
	if not settings.ray_tracing_enabled \
	and not settings.path_tracing_enabled:
		if grafics:
			grafics.queue_free()
			grafics = null
		if directional_light:
			directional_light.queue_free()
			directional_light = null
		if world_environment:
			world_environment.queue_free()
			world_environment = null
		if baked_scene:
			baked_scene.visible = false
		return
	if settings.ray_tracing_enabled:
		if grafics == null:
			grafics = preload(
				"Scenes/grafics.tscn"
			).instantiate()
			add_child(grafics)
		if directional_light == null:
			directional_light = preload(
				"Scenes/directional_light_3d.tscn"
			).instantiate()
			add_child(directional_light)
	if settings.path_tracing_enabled:
		if world_environment == null:
			world_environment = WorldEnvironment.new()
			add_child(world_environment)
			var e = preload(
				"Material/rtx_environment.tres"
			).duplicate(true)
			world_environment.environment = e
		_create_lightmap_gi()
		if baked_scene:
			baked_scene.visible = true
func _apply_default_state() -> void:
	if not _is_default_allowed():
		settings.default_enabled = false
		if env_default:
			env_default.queue_free()
			env_default = null
		if directlight_default:
			directlight_default.queue_free()
			directlight_default = null
		return
	if settings.default_enabled:
		if env_default == null:
			env_default = WorldEnvironment.new()
			add_child(env_default)
		if directlight_default == null:
			directlight_default = DirectionalLight3D.new()
			add_child(directlight_default)
	else:
		if env_default:
			env_default.queue_free()
			env_default = null
		if directlight_default:
			directlight_default.queue_free()
			directlight_default = null
func _is_default_allowed() -> bool:
	return not (
		settings.ray_tracing_enabled
		or
		settings.path_tracing_enabled
	)
func default_set(enable: bool) -> void:
	if not env_default \
	or not directlight_default:
		return
	if enable:
		if env_default.environment == null:
			env_default.environment = Environment.new()
		env_default.environment.background_mode = (
			Environment.BG_SKY
		)
		env_default.environment.ambient_light_energy = 0.8
		env_default.environment.ambient_light_color = (
			Color(1, 1, 1)
		)
		var sky := Sky.new()
		var sky_material := (
			ProceduralSkyMaterial.new()
		)
		sky_material.sky_top_color = (
			Color(0.4, 0.6, 1.0)
		)
		sky_material.sky_horizon_color = (
			Color(0.9, 0.9, 1.0)
		)
		sky_material.ground_bottom_color = (
			Color(0.2, 0.2, 0.25)
		)
		sky.sky_material = sky_material
		env_default.environment.sky = sky
		directlight_default.visible = true
		directlight_default.light_energy = 1.0
		directlight_default.shadow_enabled = true
		directlight_default.light_color = (
			Color(1.0, 0.95, 0.85)
		)
		return
	if not enable:
		if env_default.environment == null:
			env_default.environment = Environment.new()
		env_default.environment.background_mode = (
			Environment.BG_SKY
		)
		env_default.environment.ambient_light_energy = 0.35
		env_default.environment.ambient_light_color = (
			Color(0.9, 0.9, 1.0)
		)
		directlight_default.visible = true
		directlight_default.light_energy = 0.3
		directlight_default.shadow_enabled = false
		directlight_default.light_color = (
			Color(0.7, 0.75, 1.0)
		)
func _update_environment() -> void:
	if world_environment == null:
		return
	var env = world_environment.environment
	if env == null:
		return
	var sky := Sky.new()
	var mat := PanoramaSkyMaterial.new()
	if settings.time_of_day == "day":
		mat.panorama = preload(
			"assets/day_sky_cover.jpg"
		)
		if directional_light:
			directional_light.light_energy = 1.0
			directional_light.light_color = (
				Color(1, 0.95, 0.8)
			)
	elif settings.time_of_day == "night":
		mat.panorama = preload(
			"assets/night_sky_cover.jpg"
		)
		if directional_light:
			directional_light.light_energy = 0.2
			directional_light.light_color = (
				Color(0.6, 0.7, 1.0)
			)
	sky.sky_material = mat
	env.sky = sky
func _update_graphics() -> void:
	if grafics == null:
		return
	var rp = grafics.find_child(
		"ReflectionProbe",
		true,
		false
	)
	if rp:
		rp.size = settings.size
	var gi = grafics.find_child(
		"VoxelGI",
		true,
		false
	)
	if gi:
		gi.size = settings.size
