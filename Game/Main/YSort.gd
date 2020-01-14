extends YSort
func _process(delta):
	if get_parent().get_node("CanvasModulate").call("get_tick") >= 200 and get_parent().get_node("CanvasModulate").call("get_tick") <= 450 and randi() % 256 == 1:
		var enemy = load("res://character/Boss/Boss.tscn").instance()
		enemy.position = Vector2(randi() % 200 - 100, randi() % 200 - 100)
		print(enemy.position)
		add_child(enemy)
func _ready():
	pass
