extends Node

enum InputDevice {
	KEYBOARD,
	GAMEPAD
}
const langs := ["en","de","es","it"]
var last_input_device: InputDevice = InputDevice.KEYBOARD
var _lang_id := 0
func _input(event):
	if event is InputEventKey or event is InputEventMouse:
		last_input_device = InputDevice.KEYBOARD
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		last_input_device = InputDevice.GAMEPAD
	if Input.is_action_just_pressed("debug_3"):
		_lang_id += 1
		if _lang_id >= langs.size():
			_lang_id = 0
		TranslationServer.set_locale(langs[_lang_id])
		print("lang set to ",langs[_lang_id],_lang_id)

		
func get_action_key(action_name: StringName) -> String:
	var last_device = last_input_device
	var events = InputMap.action_get_events(action_name)
	for event in events:
		match last_device:
			InputDevice.KEYBOARD:
				if event is InputEventKey:
					return OS.get_keycode_string(event.physical_keycode)
				elif event is InputEventMouse:
					return get_mouse_button_name(event.button_mask)
			InputDevice.GAMEPAD:
				if event is InputEventJoypadButton:
					return get_gamepad_button_name(event.button_index)
				elif event is InputEventJoypadMotion:
					return get_gamepad_axis_name(event.axis)
	return "Unbound"
func get_gamepad_button_name(index: int) -> String:
	match index:
		JOY_BUTTON_A: return "A"
		JOY_BUTTON_B: return "B"
		JOY_BUTTON_X: return "X"
		JOY_BUTTON_Y: return "Y"
		JOY_BUTTON_RIGHT_SHOULDER: return tr("JOY_BUTTON_RIGHT_SHOULDER")
		JOY_BUTTON_LEFT_SHOULDER: return tr("JOY_BUTTON_LEFT_SHOULDER")
		_: return tr("BUTTON")+" " + str(index)
func get_gamepad_axis_name(axis: int) -> String:
	match axis:
		JOY_AXIS_LEFT_X: return tr("JOY_AXIS_LEFT")
		JOY_AXIS_LEFT_Y: return tr("JOY_AXIS_LEFT")
		JOY_AXIS_RIGHT_X: return tr("JOY_AXIS_RIGHT")
		JOY_AXIS_RIGHT_Y: return tr("JOY_AXIS_RIGHT")
		JOY_AXIS_TRIGGER_LEFT: return tr("JOY_AXIS_TRIGGER_LEFT")
		JOY_AXIS_TRIGGER_RIGHT: return tr("JOY_AXIS_TRIGGER_RIGHT")
		_: return tr("AXIS")+" " + str(axis)
func get_mouse_button_name(index: int) -> String:
	match index:
		MOUSE_BUTTON_LEFT: return tr("MOUSE_BUTTON_LEFT")
		MOUSE_BUTTON_MIDDLE: return tr("MOUSE_BUTTON_MIDDLE")
		MOUSE_BUTTON_RIGHT: return tr("MOUSE_BUTTON_RIGHT")
		_: return tr("BUTTON")+" " + str(index)
