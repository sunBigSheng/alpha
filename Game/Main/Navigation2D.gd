extends Navigation2D
enum {dirt,grass,sand,water,bed_feet,
	bed_head,cobblestone,cobblestone_mossy,
	deadbush,gold_block,gravel,hay_block,ice,
	iron_block,log_big_oak,log_birch,log_jungle,
	log_oak,melon,mushroom_brown,mushroom_red,
	plant_grass,redstone_lamp,stone,torch,planks,unknow}
var size = 128

func _ready():
	pass
	
var unwalkable = [-1,water]
func _on_Ground_generate_finished():
	for i in range(-0.5 * size,0.5 * size):
		for j in range(-0.5 * size,0.5 * size):
			if !unwalkable.has(get_parent().get_node("Ground").get_cell(i,j)):
				$TileMap.set_cell(i,j,0)
	$TileMap.update_dirty_quadrants()
			
func set_mesh(pos,cell):
	if cell == -1:
		$TileMap.set_cellv(pos,0)
		$TileMap.update_dirty_quadrants()
	else:
		$TileMap.set_cellv(pos,-1)
		$TileMap.update_dirty_quadrants()
		
	