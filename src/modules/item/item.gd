extends RigidBody3D
class_name Item

@export_enum("box","unknown") var item_type: String
var use_local := true
var collision := true:
	set(value):
		set_collision_layer_value(1,value)
		freeze = !value
		if value:
			linear_velocity = Vector3.ZERO
			angular_velocity = Vector3.ZERO
			sleeping = false
			can_sleep = true
		else:
			wake_neighbors(self)
		
var target_pos = null
var target_rot = null

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target_pos == null:
		return
	if use_local:
		position = position.lerp(target_pos, delta * 10)
		rotation = rotation.lerp(target_rot, delta * 10)
	else:
		global_position = global_position.lerp(target_pos, delta * 10)
		global_rotation = global_rotation.lerp(target_rot, delta * 10)
		
		
func wake_neighbors(body: RigidBody3D):
	var space_state = body.get_world_3d().direct_space_state
	var shape = body.shape_owner_get_shape(0, 0)

	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = shape
	query.transform = body.global_transform
	query.collision_mask = body.collision_mask  # optional
	query.collide_with_bodies = true

	var results = space_state.intersect_shape(query, 32)
	for result in results:
		var collider = result.get("collider")
		if collider is RigidBody3D and collider.sleeping:
			collider.sleeping = false
