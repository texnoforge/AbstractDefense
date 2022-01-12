extends Node2D

var MAP_SIZE = Vector2(256, 256)

var CAMERA_DELTA = 2000
var ZOOM_STEP = 1.25
var ZOOM_MIN = 0.1
var ZOOM_MAX = 10

var viewport : Viewport
var tile_map : TileMap
var camera : Camera2D


func _ready():
	viewport = get_viewport()
	tile_map = $RockMap
	camera = $TopCamera
	
	gen_map()
	
	camera.position = MAP_SIZE / 2 * tile_map.cell_size
	camera.limit_right = MAP_SIZE.x * tile_map.cell_size.x
	camera.limit_bottom = MAP_SIZE.y * tile_map.cell_size.y
	

func _input(event):
	if event is InputEventMouseButton:
		# camera zooming
		if event.is_pressed():
			if event.button_index == 4: # scroll up -> zoom out
				camera.zoom /= ZOOM_STEP
				if camera.zoom.x < ZOOM_MIN:
					camera.zoom = Vector2(ZOOM_MIN, ZOOM_MIN)
			elif event.button_index == 5:  # scroll down -> zoom in
				camera.zoom *= ZOOM_STEP
				if camera.zoom.x > ZOOM_MAX:
					camera.zoom = Vector2(ZOOM_MAX, ZOOM_MAX)
	elif event.is_action_released('app_toggle_fullscreen'):
		OS.set_window_fullscreen(!OS.window_fullscreen)
	elif event.is_action_released('app_exit'):
		get_tree().quit()

 
func _process(delta):
	# camera movement
	var cmove = Vector2()
	
	if Input.is_action_pressed('ui_left'):
		cmove.x -= 1
	if Input.is_action_pressed('ui_right'):
		cmove.x += 1
	if Input.is_action_pressed('ui_up'):
		cmove.y -= 1
	if Input.is_action_pressed('ui_down'):
		cmove.y += 1
	
	if cmove.x != 0 or cmove.y != 0:
		# camera.position doesn't match actual camera position when it's out of limits
		var cc = camera.get_camera_screen_center()
		camera.position.x = cc.x + (cmove.x * delta * camera.zoom.x * CAMERA_DELTA)
		camera.position.y = cc.y + (cmove.y * delta * camera.zoom.y * CAMERA_DELTA)

	if Input.is_action_just_released('ui_accept'):
		var mouse_gpos = get_global_mouse_position()
		print("mouse at: %s" % mouse_gpos)
		print("camera at: %s" % camera.position)

	# pass world coords transform to terrain shader
	tile_map.material.set_shader_param('global_transform', get_global_transform())


func gen_map():
	var t_start = OS.get_ticks_usec()
	
	var noise = OpenSimplexNoise.new()

	noise.seed = randi()
	noise.octaves = 4
	noise.period = 30.0
	noise.persistence = 0.8
	
	for i in range(MAP_SIZE.x):
		for j in range(MAP_SIZE.y):
			var r = noise.get_noise_2d(i, j)
			if r > 0.2:
				tile_map.set_cell(i, j, 0);

	var t_gen = OS.get_ticks_usec()
	
	tile_map.update_bitmask_region(Vector2(), MAP_SIZE)

	var t_at = OS.get_ticks_usec()

	print("map procgen in %f s" % ((t_gen - t_start) * 0.000001))
	print("map autotile in %f s" % ((t_at - t_gen) * 0.000001))
	print("map generated in %f s" % ((t_at - t_start) * 0.000001))
