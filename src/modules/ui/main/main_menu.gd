extends Control
@export var manager: GameManager
var IN_GAME_MODE: bool = false:
	set(value):
		if value:
			$Box/Paper/Label/VBox/Center/VBox/Continue.show()
			$Background.hide()
		else:
			$Box/Paper/Label/VBox/Center/VBox/Continue.hide()
			$Background.show()
			
func _ready() -> void:
	$Box/Paper/Label/VBox/Center/VBox/Continue.hide()
	$Settings.hide()
	$Credits.hide()


func _on_play_tutorial_pressed() -> void:
	$Settings.hide()
	$Credits.hide()
	manager.start_level("tutorial")


func _on_play_pressed() -> void:
	$Settings.hide()
	$Credits.hide()
	manager.start_level("level1")


func _on_settings_pressed() -> void:
	$Settings.visible = !($Settings.visible)
	$Credits.hide()

func _on_credits_pressed() -> void:
	$Settings.hide()
	$Credits.visible = !($Credits.visible)
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_continue_pressed() -> void:
	$Settings.hide()
	$Credits.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	self.hide()
