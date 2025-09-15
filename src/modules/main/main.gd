extends Node

class_name GameManager

@export var level_tutorial: PackedScene

func start_level(level_name: String)-> void:
	get_tree().paused = false
	for item in %ItemsContainer.get_children():
		item.queue_free()
	match level_name:
		"main_menu":
			for old_level in %CurrentLevel.get_children():
				old_level.queue_free()
			%MainMenu.IN_GAME_MODE = false
			%MainMenu.show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		"tutorial":
			var new_level = level_tutorial.instantiate()
			for old_level in %CurrentLevel.get_children():
				old_level.queue_free()
			%CurrentLevel.add_child(new_level)
			%MainMenu.IN_GAME_MODE = true
			%MainMenu.hide()
		_:
			printerr("level_name conflict")
