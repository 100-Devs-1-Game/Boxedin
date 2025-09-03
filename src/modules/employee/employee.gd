extends CharacterBody3D

const JUMP_VELOCITY   := 3.0
const WALKING_SPEED   := 1.5
const SPRINTING_SPEED := 3.0
const CROUCHING_SPEED := 0.5
const CROUCHING_DEPTH := 0.8
const MOUSE_SENS      := 0.15
const HALF_PI         := PI/2
@export var interaction_raycast: RayCast3D
@export var head: Node3D
@export var hands: Node3D
var is_crouching := false
var current_speed := 1.0
@onready var items_container := $/root/Main/Game/ItemsContainer
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_event := event as InputEventMouseMotion
		if Input.is_action_pressed("rotate_obj") && hands.get_child_count() >= 1:
			var obj_in_hand = hands.get_child(0) as Item
			obj_in_hand.target_rot = obj_in_hand.target_rot - Vector3(deg_to_rad(-mouse_event.relative.y * MOUSE_SENS),0,deg_to_rad(-mouse_event.relative.x * MOUSE_SENS))
		else:
			rotate_y(deg_to_rad(-mouse_event.relative.x * MOUSE_SENS))
			head.rotate_x(deg_to_rad(-mouse_event.relative.y * MOUSE_SENS))
			var c_rotation = Vector3(clamp(head.rotation.x,-HALF_PI,HALF_PI),head.rotation.y,head.rotation.z)
			head.rotation = c_rotation
	if Input.is_action_just_released("rotate_obj") && hands.get_child_count() >= 1:
		var obj_in_hand = hands.get_child(0) as Item
		obj_in_hand.target_rot = Vector3.ZERO
		
func _physics_process(delta: float) -> void:
#region Movement
	# Inputs
	current_speed = WALKING_SPEED;
	if Input.is_action_pressed("move_crouch"):
		is_crouching = true
	if Input.is_action_just_released("move_crouch"):
		is_crouching = false
	if Input.is_action_pressed("move_faster"):
		current_speed = SPRINTING_SPEED
		is_crouching = false
	if is_crouching:
		current_speed = CROUCHING_SPEED
		head.position = head.position.lerp( Vector3(0,1.5-CROUCHING_DEPTH,0), delta * 7)
	else:
		head.position = head.position.lerp( Vector3(0,1.5,0), delta * 7)
	
	# Gravity
	var vel = velocity
	if not is_on_floor():
		vel += get_gravity() * delta
	else:
		if Input.is_action_just_pressed("move_jump"):
			vel.y = JUMP_VELOCITY
	var direction_input = Input.get_vector("move_left","move_right","move_forward","move_back")
	var direction = (transform.basis * Vector3(direction_input.x,0, direction_input.y)).normalized()
	if direction != Vector3.ZERO:
		vel.x = direction.x * current_speed
		vel.z = direction.z * current_speed
	else:
		vel.x = move_toward(velocity.x,0, current_speed)
		vel.z = move_toward(velocity.z,0, current_speed)
	velocity = vel
	move_and_slide()
#endregion
#region Interact
	if interaction_raycast.is_colliding() && hands.get_child_count() == 0:
		var collider = interaction_raycast.get_collider() as Node3D
		if collider is Item:
			if Input.is_action_just_pressed("grab"):
				var item = collider
				var global_pos = item.global_position
				var global_rot = item.global_rotation
				item.get_parent().remove_child(item)
				hands.add_child(item)
				item.global_position = global_pos
				item.global_rotation = global_rot
				item.use_local = true
				item.collision = false
				item.target_pos = Vector3.ZERO
				item.target_rot = Vector3.ZERO
	else:
		if hands.get_child_count() >= 1 && Input.is_action_just_pressed("grab"):
			var item = hands.get_child(0)
			var global_pos = item.global_position
			var global_rot = item.global_rotation
			item.get_parent().remove_child(item)
			items_container.add_child(item)
			item.global_position = global_pos
			item.global_rotation = global_rot
			item.use_local = true
			item.target_pos = null
			item.target_rot = null
			item.collision = true
#endregion
