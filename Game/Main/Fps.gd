extends Label

func _process(delta):
	text = "Fps:" + str(floor(1/delta))