extends Node


var i = 0
var n = 5
var args0 = []
var args1 = []

func _ready():
	var shape = Global.scene.Shape.instance()
	var cell = Global.scene.Cell.instance()
	var count = n*n-1
	
	for _i in count:
		shape.add_child(cell.duplicate())
	
	for _i in Global.list.shapes.keys():
		for _j in Global.list.shapes[_i].keys():
			args0.append(_i)
			args1.append(_j)

	shape.rect_position = Global.list.window_size.center
	add_child(shape)
	pass

func _process(delta):
	pass

func _on_Timer_timeout():
	Global.node.TimeBar.value += 10
	if Global.node.TimeBar.value >= Global.node.TimeBar.max_value:
		Global.node.TimeBar.value -= Global.node.TimeBar.max_value
		
		var shape = get_node("Shape")
		
		for _i in  n*n-1:
			var cell_ = shape.get_child(_i)
			var m = cell_.get_modulate()
			m.a = 0
			cell_.set_modulate(m)
			
		for _i in Global.list.shapes[args0[i]][args1[i]]:
			var cell_ = shape.get_child(_i)
			var m = cell_.get_modulate()
			m.a = 1
			cell_.set_modulate(m)
			
		i += 1
		
		if i >= args0.size():
			i = 0
