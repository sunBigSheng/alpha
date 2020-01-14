extends Node2D

var wood = 0
var is_server = true
var SERVER_PORT = 80
var MAX_PLAYERS = 2
var SERVER_IP = 12

func world_to_map(pos):
	return $Ground.world_to_map(pos)

func get_tick():
	return $CanvasModulate.call("get_tick")

func set_building(pos,cell):
	if $Ground/Building.get_cellv(world_to_map(pos)) != cell:
		add_wood(-1)
		$Ground.call("set_building",pos,cell)
		$Navigation2D.call("set_mesh",world_to_map(pos),cell)

func get_cellG(pos):
	return $Ground.call("get_cellv",world_to_map(pos))

func get_cellF(pos):
	return $Ground.call("get_floor",pos)
	
func get_player_position():
	return $YSort/Player.position
	
func _get_path(start,end):
	var path = $Navigation2D.get_simple_path(start,end,false)
	return path
func get_closet_point(to):
	return $Navigation2D.get_closest_point(to)
func add_wood(num):
	wood += num
	$HUD/Wood.text = "Wood:" + str(wood)
var HP = 100
func add_HP(value):
	HP += value
	$HUD/HP.text = "HP:" + str(floor(HP))
func get_HP():
	return HP
func get_wood():
	return wood
func _on_Player_attack(pos):
	$Ground.call("set_building",pos,-1)
	var bomb = load("res://Tile/booom/bomb.tscn").instance()
	add_child(bomb)
	bomb.position = pos

func _on_Player_place_in_building(pos):
	get_tree().call_group("Kids","is_in_cell",pos)
	
func _on_Player_place_in_floor(pos):
	$Ground.call("set_floor",pos,6)
	var bomb = load("res://Tile/booom/bomb.tscn").instance()
	add_child(bomb)
	bomb.position = pos
func _ready():
	if is_server == true:
		var peer = NetworkedMultiplayerENet.new()
		peer.create_server(SERVER_PORT, MAX_PLAYERS)
		get_tree().set_network_peer(peer)
	else:
		var peer = NetworkedMultiplayerENet.new()
		peer.create_client(SERVER_IP, SERVER_PORT)
		get_tree().set_network_peer(peer)

func _on_Button_pressed():
	$YSort/Player.set_process(true)
	$HUD/Tabs.visible = false
	$CanvasModulate.call("reset")
	HP = 100
	$HUD/HP.text = "HP:100"