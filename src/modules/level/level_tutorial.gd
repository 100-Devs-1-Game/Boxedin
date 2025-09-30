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
@onready var box_spawner: BoxSpawner = $Map/BoxSpawner
@onready var game_manager: GameManager

var _items_in_truck := 0
var last_step_timer: SceneTreeTimer
var _s_font := "[font=res://addons/font/Jersey10-S.otf]"
var _input_device := Keys.InputDevice.KEYBOARD
var _current_step := STEP_MOVE:
	set(value):
		_current_step = value
		_redraw_tasks()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_node("/root/Main") as GameManager
	_redraw_tasks()
	employee.item_picked_up.connect(_on_item_picked_up)
	employee.item_rotation_status_changed.connect(_on_item_rotation_status_changed)
	box_spawner.spawn_box()

func _input(_event: InputEvent) -> void:
	if Keys.last_input_device != _input_device:
		_input_device = Keys.last_input_device
		_redraw_tasks()
	if _current_step == STEP_MOVE && Input.is_action_just_pressed("move_forward"):
		_current_step = STEP_TAKE_BOX
		box_spawner.release_boxes(3)
	if Input.is_action_just_pressed("debug_2"):
		_current_step += 1
	if Input.is_action_just_pressed("debug_3"):
		call_deferred("_redraw_tasks")

func _physics_process(_delta: float) -> void:
	if _items_in_truck >= 1 && _current_step == STEP_DROP_BOX:
		_current_step = STEP_CLOSE_TRUCK
	elif _current_step > STEP_DROP_BOX && _items_in_truck == 0:
		_current_step = STEP_DROP_BOX
	
func _on_item_picked_up(item: Item)-> void:
	if item.item_type == "box" && _current_step == STEP_TAKE_BOX:
		_current_step = STEP_ROTATE_BOX
func _on_item_rotation_status_changed(is_rotated: bool)->void:
	if _current_step == STEP_ROTATE_BOX && is_rotated:
		_current_step = STEP_DROP_BOX
		if $truck/TruckDoor/Interactable._status == 0:
			$truck/TruckDoor/Interactable.trigger()
func _get_move_keys() -> String:
	var move_keys = Keys.get_action_key("move_forward")
	if Keys.get_action_key("move_forward") != Keys.get_action_key("move_left"):
		move_keys = Keys.get_action_key("move_forward")+Keys.get_action_key("move_left")+Keys.get_action_key("move_back")+Keys.get_action_key("move_right")
	return move_keys
func _strike(text: String) -> String:
	return _s_font + "[s]" + text + "[/s]" + "[/font]"
	
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


func _on_truck_area_3d_body_entered(body: Node3D) -> void:
	if body is Item:
		_items_in_truck += 1


func _on_truck_area_3d_body_exited(body: Node3D) -> void:
	if body is Item:
		_items_in_truck -= 1


func _on_animation_finished(anim_name: StringName) -> void:
	if _current_step == STEP_CLOSE_TRUCK && anim_name == "open_truck" && $truck/TruckDoor/Interactable._status == 0:
		_current_step = STEP_PRE_LEAVE
		_last_step_in(6)

func _last_step_in(delay: float):
	var this_timer = get_tree().create_timer(delay)
	last_step_timer = this_timer
	await last_step_timer.timeout
	if last_step_timer != this_timer:
		return
	if _current_step == STEP_PRE_LEAVE:
		_current_step = STEP_LEAVE


func _on_exit_triggered() -> void:
	if _current_step == STEP_LEAVE:
		if game_manager:
			game_manager.start_level("main_menu")
		self.queue_free()
