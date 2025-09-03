extends Node3D
@export var boxes: Array[PackedScene]
@onready var items_container = $/root/Main/Game/ItemsContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spawn_position: Node3D = $SpawnPosition

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_1"):
		animation_player.play("animation_door_open")
	if event.is_action_released("debug_1"):
		animation_player.play_backwards("animation_door_open")
	if event.is_action_pressed("debug_0"):
		var new_box: Node3D = boxes[0].instantiate()
		items_container.add_child(new_box)
		new_box.global_position = spawn_position.global_position
		
