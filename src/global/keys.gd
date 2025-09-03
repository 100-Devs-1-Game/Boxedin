extends Node

enum InputDevice {
	KEYBOARD,
	GAMEPAD
}

var last_input_device: InputDevice = InputDevice.KEYBOARD

func _input(event):
	if event is InputEventKey or event is InputEventMouse:
		last_input_device = InputDevice.KEYBOARD
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		last_input_device = InputDevice.GAMEPAD
		
func get_action_key(action_name: String) -> String:
	var last_device = last_input_device
	var events = InputMap.action_get_events(action_name)
	for event in events:
		match last_device:
			InputDevice.KEYBOARD:
				if event is InputEventKey:
					return OS.get_keycode_string(event.physical_keycode)
				elif event is InputEventMouse:
					return event.as_text()
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
		_: return "Button " + str(index)
func get_gamepad_axis_name(axis: int) -> String:
	match axis:
		JOY_AXIS_LEFT_X: return "Left Stick"
		JOY_AXIS_LEFT_Y: return "Left Stick"
		JOY_AXIS_RIGHT_X: return "Right Stick"
		JOY_AXIS_RIGHT_Y: return "Right Stick"
		JOY_AXIS_TRIGGER_LEFT: return "Left Trigger"
		JOY_AXIS_TRIGGER_RIGHT: return "Right Trigger"
		_: return "Axis " + str(axis)
