extends Area2D

var points:int=50
@export var scene_to_load: PackedScene
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	body.add_score(points)
	get_tree().change_scene_to_packed(scene_to_load)
