extends StaticBody2D

var left = 1.0
var pos
var destorying = false
func _ready():
	pos = $Sprite.position
func _process(delta):
	if destorying == true:
		left -= delta * 0.1
		$ProgressBar.value = (1 - left) * 100
		$Sprite.position = pos + Vector2(randi() % 3 - 1,randi() % 3 - 1)
	#print(left)
	if left <= 0:
		$AnimationPlayer.play("down")
func _on_Button_button_down():
	destorying = true
	$ProgressBar.visible = true
	
func _on_Button_button_up():
	destorying = false
	$ProgressBar.visible = false

func _on_AnimationPlayer_animation_finished(anim_name):
	get_parent().get_parent().call("add_wood",randi() % 5 + 5)
	queue_free()

