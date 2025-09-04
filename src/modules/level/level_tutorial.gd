extends Node
const STEP_MOVE := 0
const STEP_TAKE_BOX := 1
const STEP_ROTATE_BOX := 2
const STEP_DROP_BOX := 3
const STEP_CLOSE_TRUCK := 4
const STEP_PRE_LEAVE := 5
const STEP_LEAVE := 6
@onready var employee: Employee = %Employee
@onready var hud: Hud = $Hud
var _s_font := "[font=res://addons/font/Jersey10-S.otf]"
var _input_device := Keys.InputDevice.KEYBOARD
var _current_step := STEP_MOVE:
	set(value):
		_current_step = value
		_redraw_tasks()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_redraw_tasks()
	employee.item_picked_up.connect(_on_item_picked_up)
	employee.item_rotation_status_changed.connect(_on_item_rotation_status_changed)

func _input(_event: InputEvent) -> void:
	if Keys.last_input_device != _input_device:
		_input_device = Keys.last_input_device
		_redraw_tasks()
	if _current_step == STEP_MOVE && Input.is_action_just_pressed("move_forward"):
		_current_step = STEP_TAKE_BOX
	if Input.is_action_just_pressed("debug_2"):
		_current_step += 1
	if Input.is_action_just_pressed("debug_3"):
		call_deferred("_redraw_tasks")

func _on_item_picked_up(item: Item)-> void:
	if item.item_type == "box" && _current_step == STEP_TAKE_BOX:
		_current_step = STEP_ROTATE_BOX
func _on_item_rotation_status_changed(is_rotated: bool)->void:
	if _current_step == STEP_ROTATE_BOX && is_rotated:
		_current_step = STEP_DROP_BOX
func _get_move_keys() -> String:
	var move_keys = Keys.get_action_key("move_forward")
	if Keys.get_action_key("move_forward") != Keys.get_action_key("move_left"):
		move_keys = Keys.get_action_key("move_forward")+Keys.get_action_key("move_left")+Keys.get_action_key("move_back")+Keys.get_action_key("move_right")
	return move_keys
func _strike(text: String) -> String:
	return _s_font + text + "[/font]"
	
func _redraw_tasks() -> void:
	hud.task_panel.title = tr("TUTORIAL")
	var f_keys = {
		"move_keys": _get_move_keys(),
		"grab_key": Keys.get_action_key("grab"),
		"rotate_key": Keys.get_action_key("rotate_obj"),
		"interact_key": Keys.get_action_key("interact")
	}
	var tasks := []
	match _current_step:
		STEP_MOVE:
			tasks.append(tr("TUT_TASK_MOVE").format(f_keys))
			tasks.append(tr("TUT_TASK_TAKE_BOX").format(f_keys))
			hud.info.text = tr("TUT_INFO_FIRST_BOX")
		STEP_TAKE_BOX:
			tasks.append(_strike(tr("TUT_TASK_MOVE").format(f_keys)))
			tasks.append(tr("TUT_TASK_TAKE_BOX").format(f_keys))
			hud.info.text = tr("TUT_INFO_FIRST_BOX")
		STEP_ROTATE_BOX:
			tasks.append(_strike(tr("TUT_TASK_MOVE").format(f_keys)))
			tasks.append(_strike(tr("TUT_TASK_TAKE_BOX").format(f_keys)))
			tasks.append(tr("TUT_TASK_ROT_BOX").format(f_keys))
			hud.info.text = tr("")
		STEP_DROP_BOX:
			tasks.append(_strike(tr("TUT_TASK_MOVE").format(f_keys)))
			tasks.append(_strike(tr("TUT_TASK_TAKE_BOX").format(f_keys)))
			tasks.append(_strike(tr("TUT_TASK_ROT_BOX").format(f_keys)))
			tasks.append(tr("TUT_TASK_DROP_BOX").format(f_keys))
			hud.info.text = tr("TUT_INFO_SORT")
		STEP_CLOSE_TRUCK:
			tasks.append(_strike(tr("TUT_TASK_MOVE").format(f_keys)))
			tasks.append(_strike(tr("TUT_TASK_TAKE_BOX").format(f_keys)))
			tasks.append(_strike(tr("TUT_TASK_ROT_BOX").format(f_keys)))
			tasks.append(_strike(tr("TUT_TASK_DROP_BOX").format(f_keys)))
			tasks.append(tr("TUT_TASK_CLOSE_TRUCK").format(f_keys))
			hud.info.text = ""
		STEP_PRE_LEAVE:
			tasks.append(_strike(tr("TUT_TASK_MOVE").format(f_keys)))
			tasks.append(_strike(tr("TUT_TASK_TAKE_BOX").format(f_keys)))
			tasks.append(_strike(tr("TUT_TASK_ROT_BOX").format(f_keys)))
			tasks.append(_strike(tr("TUT_TASK_DROP_BOX").format(f_keys)))
			tasks.append(_strike(tr("TUT_TASK_CLOSE_TRUCK").format(f_keys)))
			hud.info.text = "TUT_INFO_GG"
		STEP_LEAVE:
			tasks.append(_strike(tr("TUT_TASK_MOVE").format(f_keys)))
			tasks.append(_strike(tr("TUT_TASK_TAKE_BOX").format(f_keys)))
			tasks.append(_strike(tr("TUT_TASK_ROT_BOX").format(f_keys)))
			tasks.append(_strike(tr("TUT_TASK_DROP_BOX").format(f_keys)))
			tasks.append(_strike(tr("TUT_TASK_CLOSE_TRUCK").format(f_keys)))
			tasks.append(tr("TUT_TASK_LEAVE").format(f_keys))
			hud.info.text = "TUT_INFO_END"
	hud.task_panel.tasks = "\n".join(tasks)
