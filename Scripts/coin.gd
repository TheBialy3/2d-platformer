extends Area2D

var bob_hight:float=3.0
var bob_speed:float=4.0
var rotate_speed:float=3.0
@export var points:int=10
@onready var start_pos:Vector2=global_position
@onready var sprite:Sprite2D=$Sprite_coin




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var time= Time.get_unix_time_from_system()
	
	
	#rotate
	sprite.scale.x=sin(time*rotate_speed)
	
	
	#bob
	var y_pos=sin(time*bob_speed)
	global_position.y=start_pos.y-y_pos*bob_hight


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	body.add_score(points)
	queue_free()
