extends Node2D

var Flood = preload("res://Flood.tscn")

var flood_objects : Array = []

onready var board = $Board
onready var astarDebug = $AstarDebug
onready var player = $Board/Player
onready var line = $Line

func _input(event):
	if event.is_action_pressed("mouse_left"):
		var target_cell = (event.position / board.cell_size).floor() * board.cell_size
		var path_points = board.get_astar_path_avoiding_obstacles_and_units(player.global_position, target_cell)
		
		line.position = board.cell_size/2 # Use offset to move line to center of tiles
		line.points = path_points
	
		remove_flood_fill()
				
		#func get_floodfill_positions(start_position: Vector2, min_range: int, max_range: int, skip_obstacles := true, skip_units := true, return_center := false) -> Array:
		var floodfill_dictionary = board.get_floodfill_positions(player.global_position, 1, 4, true, true, false)

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
