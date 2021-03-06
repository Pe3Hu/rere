extends Node


var rng = RandomNumberGenerator.new()
var list = {}
var array = {}
var scene = {}
var node = {}
var ui = {}
var obj = {}
var flag = {}
var data = {}

func init_window_size():
	list.window_size = {}
	list.window_size.width = ProjectSettings.get_setting("display/window/size/width")
	list.window_size.height = ProjectSettings.get_setting("display/window/size/height")
	list.window_size.center = Vector2(list.window_size.width/2, list.window_size.height/2)

func init_primary_key():
	list.primary_key = {}
	list.primary_key.lord = 0
	list.primary_key.dummy = 0
	list.primary_key.encounter = 0

func init_shapes():
	list.shapes = {
		"1": {
			"i": [0]
			},
		"2": {
			"i": [0,1]
			},
		"3": {
			"i": [0,1,2],
			"v": [0,1,5]
			},
		"4": {
			"i": [0,1,2,3],
			"l": [0,1,2,5],
			"t": [0,1,2,6],
			"n": [1,2,5,6],
			"o": [0,1,5,6],
			"L": [0,1,2,7],
			"N": [0,1,6,7]
			},
		"5": {
			"i": [0,1,2,3,4],
			"l": [0,1,2,3,5],
			"p": [0,1,2,5,6],
			"u": [0,1,2,5,7],
			"y": [0,1,2,3,6],
			"f": [1,5,6,7,10],
			"n": [1,2,3,5,6],
			"v": [0,1,2,5,10],
			"t": [0,1,2,6,11],
			"x": [1,5,6,7,11],
			"m": [1,2,5,6,10],
			"z": [2,5,6,7,10],
			"L": [0,1,2,3,8],
			"Y": [0,1,2,3,7],
			"F": [1,2,5,6,11],
			"P": [0,1,2,6,7],
			"N": [0,1,2,7,8],
			"Z": [0,5,6,7,12]
			}
		}
	list.color = {
		"1": {
			"i": [0,1,0]
			},
		"2": {
			"i": [0,1,0]
			}
		}
	list.layer = {} 
	list.layer.names = ["mob","projectile","pause"]
	list.layer.current = 0

func init_list():
	init_window_size()
	init_primary_key()
	init_shapes()

func init_array():
	array.figure = []

func init_scene():
	scene.Cell = preload("res://scenes/Cell.tscn")
	scene.Shape = preload("res://scenes/Shape.tscn")
	scene.Projectile = preload("res://scenes/Projectile.tscn")
	scene.Field = preload("res://scenes/Field.tscn")

func init_node():
	node.TimeBar = get_node("/root/Game/TimeBar") 
	node.Game = get_node("/root/Game") 
	node.Projectiles = get_node("/root/Game/Projectiles") 
	
func init_obj():
	obj.field = {}
	ui.bar = []

func init_data():
	data.size = {}
	data.size.bar = Vector2(91,30)
	data.size.field = Vector2(5,10)
	data.size.tile = Vector2(26,26)
	data.size.projectile = Vector2(64,65)

func init_flag():
	flag.ready = false
	flag.generate = true

func _ready():
	init_list()
	init_array()
	init_scene()
	init_node()
	init_obj()
	init_data()
	init_flag()

func add_child_node(parent_node_path_,child_node_):
	#set position if needed
	#child_node_.global_transform = global_transform
	var p = get_node(parent_node_path_)
	var parent_node = get_node(parent_node_path_).add_child(child_node_)
	
func set_node_link(node, path):
	Global.node.Field = get_node("/root/Game/Field") 
