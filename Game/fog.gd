extends Sprite

func _on_CheckButton_toggled(button_pressed):
	if button_pressed == true:
		visible = true
	else:
		visible = false