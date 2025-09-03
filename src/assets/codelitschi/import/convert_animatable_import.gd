@tool
extends EditorScenePostImport


func _post_import(scene: Node) -> Node:
	_replace_doors_with_animatable(scene, scene)
	return scene

func _replace_doors_with_animatable(node: Node, scene_root: Node) -> void:
	for child in node.get_children():
		_replace_doors_with_animatable(child, scene_root)

	if node.name.begins_with("door"):
		var anim_body := AnimatableBody3D.new()
		anim_body.name = node.name
		anim_body.transform = node.transform

		for child in node.get_children():
			child.set_owner(null)
			node.remove_child(child)
			anim_body.add_child(child)

		var parent := node.get_parent()
		if parent:
			var idx := node.get_index()
			parent.remove_child(node)
			parent.add_child(anim_body)
			anim_body.set_owner(scene_root)
			parent.move_child(anim_body, idx)

		for child2 in anim_body.get_children():
			child2.set_owner(scene_root)
