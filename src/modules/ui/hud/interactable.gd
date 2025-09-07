extends StaticBody3D
class_name Interactable
@export_enum("door","trigger","exit") var type: String
@export var animation_player: AnimationPlayer
@export var animation: StringName
signal triggered
var _status := 0
var _ui_should_be_visible := 0


func _ready() -> void:
	$UI.hide()




func _physics_process(_delta: float) -> void:
	if _ui_should_be_visible <= 0:
		$UI.visible = false	
	else:
		_ui_should_be_visible -= 1
		pass


func trigger():
	triggered.emit()
	if type == "door":
		if _status == 0:
			animation_player.play(animation)
			_status = 1
		else:
			animation_player.play_backwards(animation)
			_status = 0

	
func show_ui_at(pos: Vector3):
	var f_keys = {
		"interact_key": Keys.get_action_key("interact")
	}
	$UI.visible = true
	$UI.global_position = pos
	_ui_should_be_visible = 5
	if type == "door":
		if _status == 0:
			$UI/SubViewport/Text.text = tr("OPEN_WITH")
		else:
			$UI/SubViewport/Text.text = tr("CLOSE_WITH")
	elif type == "exit":
		$UI/SubViewport/Text.text = tr("LEAVE_WITH").format(f_keys)

func show_ui():
	var f_keys = {
		"interact_key": Keys.get_action_key("interact")
	}
	$UI.visible = true
	if _status == 0:
		if type == "door":
			$UI.position = Vector3(0,0.4,0)
	else:
		if type == "door":
			$UI.position = Vector3(0,1.3,0)
	_ui_should_be_visible = 5
	if type == "door":
		if _status == 0:
			$UI/SubViewport/Text.text = tr("OPEN_WITH").format(f_keys)
		else:
			$UI/SubViewport/Text.text = tr("CLOSE_WITH").format(f_keys)
	elif type == "exit":
		$UI/SubViewport/Text.text = tr("LEAVE_WITH").format(f_keys)
