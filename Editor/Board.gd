extends TileMap
class_name Board

func get_tile_mose_pos():
	var mouse_pos = get_local_mouse_position()
	return local_to_map(mouse_pos)

func convert_grid_pos(grid_pos):
	return Vector2(grid_pos * Gloval.cell_size) + position + Vector2.ONE * 0.5 * Gloval.cell_size
