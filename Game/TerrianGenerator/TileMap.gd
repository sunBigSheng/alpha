extends TileMap

var noise = OpenSimplexNoise.new()

var size = 128


var river_generate = false

enum {dirt,grass,sand,water,bed_feet,
	bed_head,cobblestone,cobblestone_mossy,
	deadbush,gold_block,gravel,hay_block,ice,
	iron_block,log_big_oak,log_birch,log_jungle,
	log_oak,melon,mushroom_brown,mushroom_red,
	plant_grass,redstone_lamp,stone,torch,planks,unknow}

func falloff_value(x,y):
	var value = max(abs(x)/(0.5 * size),abs(y)/(0.5 * size))
	value = evalueate(value)
	return value
	
func evalueate(x):
	var a = 3
	var b = 2.2
	var value = pow(x,a)/(pow(x,a) + pow(b - b * x,a))
	return value
	
func generate_land(size):
	print("[Generator]:Start generating lands")
	var i = 0
	for x in range(-0.5 * size,0.5 * size):
		for y in range(-0.5 * size,0.5 * size):
			var pos = Vector2(x,y)
			var height = get_height(x,y)
			if height < -0.3:
				set_cell(x,y,water)
			if height >= -0.3 and height <= -0.2:
				set_cell(x,y,sand)
			if height >= -0.2:
				set_cell(x,y,grass)
				if randi() % 200 == 1:
					var _tree = load("res://Tile/Tree.tscn").instance()
					_tree.position = map_to_world(Vector2(x,y))
					_tree.z_index = _tree.position.y
					get_parent().get_node("YSort").add_child(_tree)
			
			i = i + 1
			if i % 8192 == 0:
				print("[Generator]:",i/pow(size,2))
				
func generate(size):
	generate_land(size) # 生成海陆图
	
	if river_generate == true:
		for i in range(randi() % 100): # 随机取点作为河流的水源
			var x = randi() % size - 0.5 * size # -0.5 * size < x < 0.5 * size
			var y = randi() % size - 0.5 * size # the same as x
			if get_cell(x,y) == water:
				continue
			generate_river(x,y)
	
	generate_village(0,0)

var i = 0

func get_height(x,y):
	var value = noise.get_noise_2d(x,y) - falloff_value(x,y)
	return value
	
func get_heightv(pos):
	var value = noise.get_noise_2dv(pos) - falloff_value(pos.x,pos.y)
	return value
	
func get_closest_cell(cellP):
	var direction = Vector2(0,0)
	direction = Vector2(-1,0)
	var noise_value_min = 0
	noise_value_min = get_heightv(cellP + direction)
	if get_heightv(cellP + Vector2(0,-1)) < noise_value_min:
		direction = Vector2(0,-1)
		noise_value_min = get_heightv(cellP + Vector2(0,-1))
	if get_heightv(cellP + Vector2(1,0)) < noise_value_min:
		direction = Vector2(1,0)
		noise_value_min = get_heightv(cellP + Vector2(1,0))
	if get_heightv(cellP + Vector2(0,1)) < noise_value_min:
		direction = Vector2(0,1)
		noise_value_min = get_heightv(cellP + Vector2(0,1))
	return direction

func create_pond(river):
	for i in range(river.size()):
		var r = pow(i/32,2) # r随距离变化的关系式
		for x in range(river[i].x - 0.5 * r,river[i].x + 0.5 * r):
			for y in range(river[i].y - 0.5 * r,river[i].y + 0.5 * r):
				get_parent().call("set_building",Vector2(x,y),water)

func generate_river(x,y):
	var river = [] # 存储河流的路径
	var cellP = Vector2() # 用作后来的遍历
	cellP.x = x # 使起点为指定位置
	cellP.y = y
	print("[Generator]:The position of the river is x:",x,"y:",y)
	while get_cellv(cellP + get_closest_cell(cellP)) != water: # cellP + get_closest_cell(...)是为了
	                                                         #后续添加功能是检测到自己所添加的河流cell
		var direction = get_closest_cell(cellP)
		cellP = cellP + direction # 对位置进行移动
		river.append(cellP) # 在数组末尾加上当前cell
		get_parent().call("set_building",cellP,water)
	create_pond(river) #使河流半径随与源头的距离变化
	print("[Generator]:The length of the river is ",river.size())

func creat_road(x,y):
	for i in range(x - 1,x + 1):
		for j in range(y - 1,y + 1):
			if get_cell(i,j) == planks:
				break
			if get_cell(i,j) == water:
				set_cell(i,j,planks)
				var pos = Vector2(i,j)
				get_parent().call("add_mesh",pos)
			else:
				var pos = Vector2(i,j)
				get_parent().call("add_mesh",pos)
				set_cell(i,j,gravel)
				
func creat_house(x,y):
	var house = load("res://Village_room_small.tscn").instance()
	add_child(house)
	var room_rect = house.call("get_rect")
	for i in range(-0.5 * room_rect.x,0.5 * room_rect.x):
		for j in range(-0.5 * room_rect.y,0.5 * room_rect.y):
			var cellb = house.call("get_cellb",i,j)
			$Building.call("set_cell",x + i,y + j,cellb)
			get_parent().call("place",Vector2(x + i,y + j))
			var pos = Vector2(x + i,y + j)
			get_parent().call("add_mesh",pos)
			var cellf = house.call("get_cellf",i,j)
			$Floor.call("set_cell",x + i,y + j,cellf)
			get_parent().call("add_mesh",pos)
	house.call("queue_free")
func generate_village(x,y):
	pass

func set_building(pos,cell):
	$Building.call("set_cellv",world_to_map(pos),cell)
	get_parent().get_node("Navigation2D").call("set_mesh",world_to_map(pos),cell)
	
func set_floor(pos,cell):
	$Floor.call("set_cellv",world_to_map(pos),cell)
	
func get_floor(pos):
	return $Floor.call("get_cellv",world_to_map(pos))

signal generate_finished

func _ready():
	print("[Generator]:The terrian generator begins")
	randomize()
	generate(size)
	emit_signal("generate_finished")
	#generate_river(0,0)
