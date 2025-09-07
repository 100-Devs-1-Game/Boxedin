extends Node3D
class_name BoxSpawner
@export var boxes: Array[PackedScene]
@onready var items_container = $/root/Main/Game/ItemsContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spawn_position: Node3D = $SpawnPosition
var door_timer: SceneTreeTimer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_1"):
		animation_player.play("animation_door_open")
	if event.is_action_released("debug_1"):
		animation_player.play_backwards("animation_door_open")
	if event.is_action_pressed("debug_0"):
		spawn_box()
		

func spawn_box(box_id: int = 0):
	if box_id >= boxes.size():
		box_id = 0
	var new_box: Node3D = boxes[box_id].instantiate()
	items_container.add_child(new_box)
	new_box.global_position = spawn_position.global_position

func release_boxes(open_duration: float = 10):
	animation_player.play("animation_door_open")
	var this_timer = get_tree().create_timer(open_duration)
	door_timer = this_timer
	await door_timer.timeout
	if door_timer != this_timer:
		return
	animation_player.play_backwards("animation_door_open")
