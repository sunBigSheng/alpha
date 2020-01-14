extends CanvasModulate

var tick = 0

var days = 0
func get_tick():
	return tick
func reset():
	tick = 0
	$AnimationPlayer.stop()
	$AnimationPlayer.play("day")
func _process(delta):
	tick += delta
	if tick > 600:
		tick = 0
		days += 1
		get_parent().get_node("HUD/Days").text = "DAY" + str(days + 1)
func _ready():
	$AnimationPlayer.play("day")