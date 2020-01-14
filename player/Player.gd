extends KinematicBody2D

export var speed = 300

signal attack
signal place_in_building
signal place_in_floor

var cold_time : float
var HP
enum {dirt,grass,sand,water,bed_feet,
	bed_head,cobblestone,cobblestone_mossy,
	deadbush,gold_block,gravel,hay_block,ice,
	iron_block,log_big_oak,log_birch,log_jungle,
	log_oak,melon,mushroom_brown,mushroom_red,
	plant_grass,redstone_lamp,stone,torch,planks}

func _process(delta):
	if get_parent().get_parent().call("get_HP") < 100:
		get_parent().get_parent().call("add_HP",delta * 1.67)
		if get_parent().get_parent().call("get_HP") > 100:
			get_parent().get_parent().call("add_HP",-get_parent().get_parent().call("get_HP") + 100)
	_on_enemy_attack(0)
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if velocity.length() > 0:
		if get_parent().get_parent().call("get_cellG",position) != water:
			velocity = velocity.normalized() * speed
		else:
			if get_parent().get_parent().call("get_cellG",position) == water and get_parent().get_parent().call("get_cellF",position) == -1:
				velocity = velocity.normalized() * speed * 0.5
			if get_parent().get_parent().call("get_cellG",position) == water and get_parent().get_parent().call("get_cellF",position) != -1:
				velocity = velocity.normalized() * speed
			
	move_and_slide(velocity)
	if get_parent().get_parent().call("get_cellG",position) == water:
		get_parent().get_parent().call("add_HP",-delta * 10)
	z_index = position.y
	if velocity.length() != 0:
		$AnimatedSprite.animation = "Run"
	else:
		$AnimatedSprite.animation = "Idle"
		
	if velocity.x != 0:
		$AnimatedSprite.flip_h = velocity.x < 0
		
		
	if Input.is_mouse_button_pressed(1) and cold_time >= 0.2:
		$AnimatedSprite.animation = "Attack"
		emit_signal("attack",get_global_mouse_position())
		get_tree().call_group("Kids","Player_Attack")
		cold_time = 0
	if Input.is_mouse_button_pressed(2) and cold_time >= -1 and get_parent().get_parent().call("get_cellG",get_global_mouse_position()) != water:
		if get_parent().get_parent().call("get_wood") > 0:
			$AnimatedSprite.animation = "Attack"
			emit_signal("place_in_building",get_global_mouse_position())
			get_tree().call_group("Kids","Player_place_in_building")
			cold_time = 0
	if Input.is_mouse_button_pressed(3) and cold_time >= 0.2 and get_parent().get_parent().call("get_cellG",get_global_mouse_position()) == water:
		$AnimatedSprite.animation = "Attack"
		emit_signal("place_in_floor",get_global_mouse_position())
		cold_time = 0
	cold_time = delta + cold_time
func _on_enemy_attack(value):
	get_parent().get_parent().add_HP(value)
	if get_parent().get_parent().call("get_HP") <= 0:
		$AnimatedSprite.animation = "Dead"
		set_process(false)
		get_parent().get_parent().get_node("HUD/Tabs").visible = true
	
func _ready():
	HP = get_parent().get_parent().call("get_HP")
	$AnimatedSprite.play()
	connect("attack",get_parent().get_parent(),"_on_Player_attack")
	connect("place_in_building",get_parent().get_parent(),"_on_Player_place_in_building")
	connect("place_in_floor",get_parent().get_parent(),"_on_Player_place_in_floor")
