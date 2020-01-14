extends StaticBody2D

var durable = 1.0

func _process(delta):
	if durable <= 0:
		queue_free()

func _ready():
	pass

func _on_Tree_mouse_entered():
	print("111")
	if Input.is_mouse_button_pressed(1):
		durable -= 0.5
	