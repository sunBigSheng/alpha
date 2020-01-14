extends Node2D

var rect = Vector2(8,6)

func get_rect():
	return rect
	
func get_cellb(x,y):
	return $Building.call("get_cell",x,y)
	
func get_cellf(x,y):
	return $Floor.call("get_cell",x,y)