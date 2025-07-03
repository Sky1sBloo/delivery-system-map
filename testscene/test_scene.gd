extends Node2D

var text_callback = JavaScriptBridge.create_callback(_set_text)

func _init() -> void:
	JavaScriptBridge.eval("""
var godotBridge = {
	callback: null,
	setCallback: (cb) => this.callback = cb,
	test: (data) => this.callback(JSON.stringify(data)),
};
	""", true)
	var godot_bridge = JavaScriptBridge.get_interface("godotBridge")
	godot_bridge.setCallback(text_callback)

func _set_text(args):
	$Label.text = args
	$Label2.text = args[0] + "hi"
