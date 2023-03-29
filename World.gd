extends Node2D

var Flood = preload("res://Flood.tscn")

var flood_objects : Array = []

onready var board = $Board
onready var astarDebug = $AstarDebug
onready var player = $Board/Player
onready var player2: Node2D = $Board/Player2
onready var enemy: Node2D = $Board/Enemy
onready var line = $Line
onready var options_dialog: WindowDialog = $OptionsDialog

func _unhandled_input(event):
	if event.is_action_pressed("mouse_left"):
		var target_cell = (event.position / board.cell_size).floor() * board.cell_size
		var path_points
		
		var exception_units = []
		
		if options_dialog.selected_avoidance == options_dialog.Avoidance.OBSTACLES:
			path_points = board.get_astar_path_avoiding_obstacles(player.global_position, target_cell)
		elif options_dialog.selected_avoidance == options_dialog.Avoidance.OBSTACLES_AND_UNITS:
			path_points = board.get_astar_path_avoiding_obstacles_and_units(player.global_position, target_cell, exception_units, options_dialog.allow_unit_targets_check.pressed)
		elif options_dialog.selected_avoidance == options_dialog.Avoidance.NONE:
			path_points = board.get_astar_path(player.global_position, target_cell)
				
		var target_unit = find_units_at_position(target_cell).pop_back()
		if target_unit:
			if target_unit.is_in_group("Player"):
				line.default_color =  Color8(0, 255, 0, 255)
			if target_unit.is_in_group("Enemy"):
				line.default_color = Color8(255, 0, 0, 255)
		else:
			line.default_color = Color8(0, 0, 255, 255)
			
		line.position = board.cell_size/2 # Use offset to move line to center of tiles
		line.points = path_points
	
		remove_flood_fill()
		
		var skip_obstacles = options_dialog.skip_obstacles_check.pressed
		var unit_flooding = options_dialog.selected_unit_flooding
		var max_range = options_dialog.max_range_spin.value
		var floodfill_dictionary = board.get_floodfill_positions(player.global_position, 1, max_range, skip_obstacles, unit_flooding, false)

		var floodfill_moveable = floodfill_dictionary["Moveable"]
		var floodfill_units = floodfill_dictionary["Units"]

		for flood_pos in floodfill_moveable:
			var flood = Flood.instance()
			add_child(flood)
			flood.global_position = flood_pos
			flood_objects.append(flood)
			
		for flood_pos in floodfill_units:
			var flood = Flood.instance()
			add_child(flood)
			flood.global_position = flood_pos
			
			var found_units := find_units_at_position(flood_pos)
			var last_unit = found_units.pop_back()
			if last_unit:
				if last_unit.is_in_group("Player"):
					flood.set_color(Color8(0, 255, 0, 50))
				if last_unit.is_in_group("Enemy"):
					flood.set_color(Color8(255, 0, 0, 50))
			
			flood_objects.append(flood)
	
	if event.is_action_pressed("mouse_right"):
		line.points = []
		remove_flood_fill()
	
	if event.is_action_pressed("ui_accept"):
		astarDebug.visible = !astarDebug.visible

	if event.is_action_pressed("ui_cancel"):
		options_dialog.visible = true

func find_units_at_position(search_pos : Vector2) -> Array:
	var unitArray := []
	var unitNodes = get_tree().get_nodes_in_group("Units")
	for unitNode in unitNodes:
		if unitNode.global_position == search_pos:
			unitArray.append(unitNode)
			
	return unitArray

func remove_flood_fill() -> void:
	while not flood_objects.empty():
		flood_objects.pop_back().queue_free()
