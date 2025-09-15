extends Node

@onready var main_menu: Control = %MainMenu

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if main_menu != null:
			if %CurrentLevel.get_child_count() != 0:
				if !main_menu.visible:
					main_menu.show()
					Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
					get_tree().paused = true
				else:
					Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
					main_menu.hide()
					get_tree().paused = false
		else:
			get_tree().quit()
