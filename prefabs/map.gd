extends Control


@onready var line: Line2D = $Route
@onready var invalid_json_marker = $InvalidJsonMarker
@onready var not_found_city_marker = $NotFoundCityMarker

var lines_callback = JavaScriptBridge.create_callback(set_lines)

func _init() -> void:
	JavaScriptBridge.eval("""
var godotBridge = {
	callback: null,
	setCallback: (cb) => this.callback = cb,
	showRoute: (data) => this.callback(JSON.stringify(data)),
};
	""", true)
	var godot_bridge = JavaScriptBridge.get_interface("godotBridge")
	godot_bridge.setCallback(lines_callback)


func set_lines(data):
	line.clear_points()
	var json = JSON.parse_string(data[0])
	if json == null or not json.has("path"):
		invalid_json_marker.visible = true
		print("Invalid JSON: ", data[0])
		return
		
	var path = json["path"]
	
	for city_name in path:
		var marker_name = sanitize_city_name(city_name)
		var marker_node = $LineGuide.get_node_or_null(marker_name)
		if marker_node and marker_node is Marker2D:
			line.add_point(marker_node.global_position)
		else:
			not_found_city_marker.visible = true
			print("City not found: ", marker_name)

func sanitize_city_name(city: String) -> String:
	# Remove anything in parentheses
	var without_parens := city.split("(")[0].strip_edges()

	# Remove spaces and normalize characters
	var cleaned := without_parens.replace(" ", "").replace("ñ", "n")

	return cleaned
