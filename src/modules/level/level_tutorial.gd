extends Node
@onready var hud: Hud = $Hud
var _s_font := "[font=res://addons/font/Jersey10-S.otf]"
var _input_device := Keys.InputDevice.KEYBOARD
var _current_step := 0:
	set(value):
		_current_step = value
		_redraw_tasks()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud.task_panel.title = tr("TUTORIAL")
	var move_keys = Keys.get_action_key("move_forward")
	if Keys.get_action_key("move_forward") != Keys.get_action_key("move_left"):
		move_keys = Keys.get_action_key("move_forward")+Keys.get_action_key("move_left")+Keys.get_action_key("move_back")+Keys.get_action_key("move_right")
	hud.task_panel.tasks = tr("TUT_TASK_MOVE").format({"move_keys": move_keys})
	hud.task_panel.tasks += "\n"+tr("TUT_TASK_TAKE_BOX").format({"grab_key": Keys.get_action_key("grab")})


func _input(_event: InputEvent) -> void:
	if Keys.last_input_device != _input_device:
		_input_device = Keys.last_input_device
		_redraw_tasks()
	if _current_step == 0 && Input.is_action_just_pressed("move_forward"):
		_current_step += 1
	
func _redraw_tasks() -> void:
	match _current_step:
		0:
			hud.task_panel.title = tr("TUTORIAL")
			var move_keys = Keys.get_action_key("move_forward")
			if Keys.get_action_key("move_forward") != Keys.get_action_key("move_left"):
				move_keys = Keys.get_action_key("move_forward")+Keys.get_action_key("move_left")+Keys.get_action_key("move_back")+Keys.get_action_key("move_right")
			var move = tr("TUT_TASK_MOVE").format({"move_keys": move_keys})
			var take = tr("TUT_TASK_TAKE_BOX").format({"grab_key": Keys.get_action_key("grab")})
			hud.task_panel.tasks = "\n".join([move, take])
		1:
			hud.task_panel.title = tr("TUTORIAL")
			var move_keys = Keys.get_action_key("move_forward")
			if Keys.get_action_key("move_forward") != Keys.get_action_key("move_left"):
				move_keys = Keys.get_action_key("move_forward")+Keys.get_action_key("move_left")+Keys.get_action_key("move_back")+Keys.get_action_key("move_right")
			var move = _s_font+tr("TUT_TASK_MOVE").format({"move_keys": move_keys})+"[/font]"
			var take = tr("TUT_TASK_TAKE_BOX").format({"grab_key": Keys.get_action_key("grab")})
			hud.task_panel.tasks = "\n".join([move, take])
		2:
			hud.task_panel.title = tr("TUTORIAL")
			var move_keys = Keys.get_action_key("move_forward")
			if Keys.get_action_key("move_forward") != Keys.get_action_key("move_left"):
				move_keys = Keys.get_action_key("move_forward")+Keys.get_action_key("move_left")+Keys.get_action_key("move_back")+Keys.get_action_key("move_right")
			var move = _s_font+tr("TUT_TASK_MOVE").format({"move_keys": move_keys})+"[/font]"
			var take = _s_font+tr("TUT_TASK_TAKE_BOX").format({"grab_key": Keys.get_action_key("grab")})+"[/font]"
			hud.task_panel.tasks = "\n".join([move, take])
