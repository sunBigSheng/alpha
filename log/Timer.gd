extends Timer

var is_print_tick = false

func _on_Timer_timeout():
	var time = get_parent().call("get_tick")
	if is_print_tick == true:
		print("tick:",time)
	
