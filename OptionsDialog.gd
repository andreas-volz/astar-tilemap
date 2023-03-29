extends WindowDialog

enum Avoidance {NONE, OBSTACLES, OBSTACLES_AND_UNITS}
enum UnitFlooding {
	IGNORE,
	SKIP,
	SELECT,
}

var avoidance_array = ["No Avoidance", "Avoid Obstacles", "Avoid Obstacles and Units"]
var selected_avoidance = Avoidance.OBSTACLES_AND_UNITS

var unit_flooding_array = ["Ignore Units", "Skip Units", "Select Units"]
var selected_unit_flooding = UnitFlooding.IGNORE

onready var max_range_spin: SpinBox = $CenterContainer/VBoxContainer3/VBoxContainer2/HBoxContainer/MaxRangeSpin
onready var avoidance_options: OptionButton = $CenterContainer/VBoxContainer3/VBoxContainer/AvoidanceOptions
onready var unit_flooding_options: OptionButton = $CenterContainer/VBoxContainer3/VBoxContainer2/UnitFloodingOptions
onready var skip_obstacles_check: CheckBox = $CenterContainer/VBoxContainer3/VBoxContainer2/SkipObstaclesCheck
onready var allow_unit_targets_check: CheckBox = $CenterContainer/VBoxContainer3/VBoxContainer/AllowUnitTargetsCheck
onready var max_routing_distance: SpinBox = $CenterContainer/VBoxContainer3/VBoxContainer/HBoxContainer/MaxRoutingDistance

func _ready() -> void:
	add_array_to_dropdown(avoidance_options, avoidance_array)
	avoidance_options.select(selected_avoidance)
	
	add_array_to_dropdown(unit_flooding_options, unit_flooding_array)
	unit_flooding_options.select(selected_unit_flooding)
	
func add_array_to_dropdown(dropdown, array):
	for item in array:
		dropdown.add_item(item)
	
func _on_AvoidanceOptions_item_selected(index: int) -> void:
	selected_avoidance = index

func _on_UnitFloodingOptions_item_selected(index: int) -> void:
	selected_unit_flooding = index
