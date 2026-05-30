@tool
@icon("icon.png")
class_name RTXSettings
extends Resource

@export_group("RTX")
@export var ray_tracing_enabled := true
@export var path_tracing_enabled := true

@export_group("Time")
@export_enum("day", "night") var time_of_day = "day"

@export_group("Default")
@export var default_enabled := false

@export_group("Size")
@export var size := Vector3(200, 200, 200)
