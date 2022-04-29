extends Node


class Block:
	var number = {}
	var string = {}
	var array = {}
	var list = {}
	var flag = {}
	
	func _init(input_):
		list.owner = input_.owner
		string.type = input_.type
		number.cell = input_.cell
		
		match string.type:
			"mob":
				list.hp = input_.hp
	
	func absorb(projectile_):
		list.hp.current -= projectile_.number.damage
		
		if list.hp.current <= 0:
			destroy()
			
	func destroy():
		list.owner.array.block.erase(self)
		
class Figure:
	var number = {}
	var string = {}
	var array = {}
	var list = {}
	var flag = {}
	var node = {}
	
	func _init(input_):
		number.x = Global.data.size.field.x
		number.y = Global.data.size.field.x
		number.n = number.x*number.y
		string.size = ""
		string.letter = ""
		array.block = []
		node.shape = Global.scene.Shape.instance()
		
		var cell = Global.scene.Cell.instance()
		
		for _i in number.n:
			node.shape.add_child(cell.duplicate())
		
		Global.node.Game.add_child(node.shape)
		
	func reset():
		for block in array.block:
			var cell_ = node.shape.get_child(block.number.cell)
			var m = cell_.get_modulate()
			m.a = 0
			cell_.set_modulate(m)
	
	func set_shape(size_,letter_):
		string.size = size_
		string.letter = letter_
		
		reset()
		
		array.block = []
		
		for _i in Global.list.shapes[string.size][string.letter]:
			var input = {}
			input.owner = self
			input.type = "figure"
			input.cell = _i
			
			var block = Classes.Block.new(input)
			array.block.append(block)
		
		for block in array.block:
			var cell_ = node.shape.get_child(block.number.cell)
			var m = cell_.get_modulate()
			m.a = 1
			cell_.set_modulate(m)

class Field:
	var number = {}
	var string = {}
	var array = {}
	var list = {}
	var flag = {}
	var node = {}
	
	func _init(input_):
		number.x = int(Global.data.size.field.x)
		number.y = int(Global.data.size.field.y)
		number.m = number.x*number.y
		array.cell = []
		array.mob = []
		array.projectile = []
		node.field = Global.scene.Field.instance()
		
		var cell = Global.scene.Cell.instance()
		
		for _i in number.m:
			node.field.add_child(cell.duplicate())
		
		Global.node.Game.add_child(node.field)
		Global.node.Field = {}
		Global.set_node_link(Global.node.Field,"/root/Game/Field")
		
		reset_cells()

	func reset_cells():
		for _i in number.m:
			var cell_ = node.field.get_child(_i)
			var m = cell_.get_modulate()
			m.r = 1
			m.g = 1
			m.b = 1
			m.a = 0.5
			cell_.set_modulate(m)
			cell_.get_node("HP").text = ""

	func generate_mob():
		if Global.list.layer.names[Global.list.layer.current] == "mob":
			var rank = 1
			var option = {}
			option.size = String(rank)
			var options = []
			
			for letter in Global.list.shapes[option.size].keys():
				option.letter = letter
				
				if check_spawn_shape(option):
					options.append(option)
			
			Global.rng.randomize()
			var index_r = Global.rng.randi_range(0,options.size()-1)
			
			var input = {}
			input.size = options[index_r].size 
			input.letter = options[index_r].letter 
			
			options = []
			Global.rng.randomize()
			var spawn_space = number.x * 1
			
			for x in spawn_space:
				if !array.cell.has(x):
					options.append(x)
			
			index_r = Global.rng.randi_range(0,options.size()-1)
			var spawn_move_shift = number.x
			input.cell = options[index_r]
			var mob = Classes.Mob.new(input)
			array.mob.append(mob)

	func generate_projectile():
		if Global.list.layer.names[Global.list.layer.current] == "projectile":
			var options = []
			var spawn_space = number.x * 1
			
			for x in range(number.m-spawn_space, number.m):
				options.append(x)
			
			Global.rng.randomize()
			var index_r = Global.rng.randi_range(0,options.size()-1)
			var spawn_move_shift = number.x
			var input = {}
			input.cell = options[index_r]
			input.damage = 7
			input.speed = 1
			input.direction = Vector2(0,-1)
			var projectile = Classes.Projectile.new(input)
			array.projectile.append(projectile)

	func check_spawn_shape(option):
		return true

	func check_spawn_space(option):
		return true

	func set_all():
		match Global.list.layer.names[Global.list.layer.current]:
			"mob":
				for mob in array.mob:
					mob.set_cells()
			"projectile":
				for projectile in array.projectile:
					projectile.move()
					
		for projectile in array.projectile:
			projectile.check_hit()

	func draw_all():
		match Global.list.layer.names[Global.list.layer.current]:
			"pause":
			#"mob":
				reset_cells()
				
				for mob in array.mob:
					mob.draw_cells()
			#"projectile":
				for projectile in array.projectile:
						projectile.draw()

class Mob:
	var number = {}
	var string = {}
	var array = {}
	var list = {}
	var flag = {}
	
	func _init(input_):
		string.size = input_.size
		string.letter = input_.letter
		number.cell = input_.cell
		number.r = Global.list.color[string.size][string.letter][0]
		number.g = Global.list.color[string.size][string.letter][1]
		number.b = Global.list.color[string.size][string.letter][2]
		array.block = []
		
		for _i in Global.list.shapes[string.size][string.letter]:
			var input = {}
			input.owner = self
			input.type = "mob"
			input.hp = {}
			input.hp.max = 10
			input.hp.current = input.hp.max
			input.cell = _i
			
			var block = Classes.Block.new(input)
			array.block.append(block)
			
		flag.active = true
		flag.destroy = false
		
		for block in array.block:
			var index_c = block.number.cell + number.cell
			Global.obj.field.array.cell.append(index_c)
	
	func draw_cells():
		if !flag.destroy:
			for block in array.block:
				var index_c = block.number.cell + number.cell
				var cell_ = Global.obj.field.node.field.get_child(index_c)
				var m = cell_.get_modulate()
				m.r = number.r
				m.g = number.g
				m.b = number.b
				m.a = 0.5
				cell_.set_modulate(m)
				cell_.get_node("HP").text = String(block.list.hp.current)
		else:
			destroy()
	
	func set_cells():
		var cells = Global.obj.field.array.cell
		
		if flag.active:
			for block in array.block:
				var index_c = block.number.cell + number.cell
				cells.erase(index_c)
		
		move()
		
		if !flag.destroy:
			for block in array.block:
				var index_c = block.number.cell + number.cell
				
				if !cells.has(index_c):
					cells.append(index_c)
	
	func move():
		if flag.active:
			number.cell += Global.obj.field.number.x
			check_finish()
		else: 
			flag.active = true
	
	func check_finish():
		flag.destroy = number.cell >= Global.obj.field.number.m
	
	func check_cell(cell_):
		var result = null
		
		for block in array.block:
			var index_c = block.number.cell + number.cell
			
			if index_c == cell_:
				result = block
	
		return result

	func destroy():
		Global.obj.field.array.mob.erase(self)

class Projectile:
	var number = {}
	var array = {}
	var list = {}
	var flag = {}
	var vec = {}
	var node = {}
	
	func _init(input_):
		#string.owner = input_.owner
		#string.type = input_.type
		number.cell = input_.cell
		number.damage = input_.damage
		number.speed = input_.speed
		vec.direction = input_.direction
		var x = number.cell % Global.obj.field.number.x
		var y = floor(number.cell / Global.obj.field.number.x)
		vec.position = Vector2(x,y)
		flag.destroy = false
		flag.hit = false
		flag.miss = false
		node.sprite = Global.scene.Projectile.instance()
		node.sprite.get_node("HP").text = String(number.damage)
		node.sprite.get_node("HP").rect_position.x -= Global.data.size.projectile.x / 6
		node.sprite.get_node("HP").rect_position.y -= Global.data.size.projectile.y / 3
		Global.node.Projectiles.add_child(node.sprite)
	
	func draw():
		if !flag.destroy:
			var vec = Global.obj.field.node.field.get_children()[number.cell].get_position()
			vec.x += Global.list.window_size.center.x
			vec += Global.data.size.tile / 2
			node.sprite.position = vec
		else:
			destroy()
	
	func move():
		for _i in number.speed:
			vec.position += vec.direction
			number.cell = vec.position.y * Global.obj.field.number.x + vec.position.x
	
	func check_hit():
		if !flag.destroy:
			if vec.position.x < 0 || vec.position.x >= Global.obj.field.number.x || vec.position.y < 0 || vec.position.y >= Global.obj.field.number.y:
				flag.miss = true
			
			for mob in Global.obj.field.array.mob:
				var block = mob.check_cell(number.cell)
				
				if block != null:
					block.absorb(self)
					#mob.draw_cells()
					flag.hit = true
			
			flag.destroy = flag.hit || flag.miss

	func destroy():
		node.sprite.queue_free()
		Global.node.Projectiles.remove_child(node.sprite)
		Global.obj.field.array.projectile.erase(self)
