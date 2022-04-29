extends Node


var i = 0
var n = 5
var args0 = []
var args1 = []

func _ready():
	
	var figure = Classes.Figure.new({})
	Global.array.figure.append(figure)
	
	Global.obj.field = Classes.Field.new({})
	
	for _i in Global.list.shapes.keys():
		for _j in Global.list.shapes[_i].keys():
			args0.append(_i)
			args1.append(_j)

	Global.array.figure[0].node.shape.rect_position.y = Global.list.window_size.center.y
	Global.node.Field.rect_position.x = Global.list.window_size.center.x

func _process(delta):
	pass

func _on_Timer_timeout():
	Global.node.TimeBar.value += 10
	if Global.node.TimeBar.value >= Global.node.TimeBar.max_value:
		Global.node.TimeBar.value -= Global.node.TimeBar.max_value
		
		Global.list.layer.current += 1
		
		if Global.list.layer.current >= Global.list.layer.names.size():
			Global.list.layer.current = 0
			
		Global.obj.field.set_all()
		Global.obj.field.draw_all()
		
		if Global.flag.generate:
			for _i in 2:
				Global.obj.field.generate_mob()
			#Global.flag.generate = false
			
			for _i in 3:
				Global.obj.field.generate_projectile()
		else:
			Global.flag.generate = true
		
		
		Global.array.figure[0].set_shape(args0[i],args1[i])
		
		i += 1
		
		if i >= args0.size():
			i = 0
