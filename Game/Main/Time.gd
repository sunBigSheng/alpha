extends Label
func _process(delta):
	var tick = get_parent().get_parent().get_node("CanvasModulate").call("get_tick")
	var time
	if tick < 300:
		time = 0.04 * tick + 12
	else:
		time = 0.04 * tick - 12
	text = str(floor(time)) + ":00"