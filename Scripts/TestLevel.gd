extends Node2D

@export var enemy: PackedScene
@export var start_location: Marker2D
@export var end_location: Marker2D

enum Tower {
	NONE,
	BASIC,
	SLOW
}

@onready var basic_tower: PackedScene = load("res://Nodes/Objects/SimpleProjectileTower.tscn")

var tower: Tower = Tower.NONE
var tower_node: Node2D

func _on_wave_spawner_timeout():
	var new_enemy = enemy.instantiate()
	new_enemy.start_location = start_location
	new_enemy.end_location = end_location
	add_child(new_enemy)
	
func _process(delta: float) -> void:
	if tower == Tower.NONE || tower_node == null:
		return
	var tile: Vector2i = $TileMap.local_to_map(get_global_mouse_position())
	var tileData: TileData = $TileMap.get_cell_tile_data(0, tile)
	var local_pos: Vector2 = $TileMap.map_to_local(tile)
	var world_pos: Vector2 = $TileMap.to_global(local_pos)
	tower_node.global_position = world_pos
	
	var atlas_coords = $TileMap.get_cell_atlas_coords(0, tile)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && atlas_coords != Vector2i(0,4):
		tower_node.get_node("TowerComponent").tower_built = true
		tower_node = null
		tower = Tower.NONE
		


func _on_build_sidebar_tower_selected(selected_tower: Tower):
	tower = selected_tower
	tower_node = basic_tower.instantiate()
	add_child(tower_node)
