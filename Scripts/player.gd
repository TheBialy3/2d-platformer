extends CharacterBody2D

signal OnUpdateHealth(health:int)
signal OnUpdateScore(score:int)

@export var move_speed :float= 100.0
@export var jump_force :float= 250.0
@export var braking:float=20
@export var gravity:float=500
@export var acceleration:float=50
var move_input:float
@export var double_jump:int =2

@onready var ui :CanvasLayer=$CanvasLayer
@onready var sprite :Sprite2D=$Sprite
@onready var anom:AnimationPlayer=$AnimationPlayer


@export var health:int=3

@onready var audio :AudioStreamPlayer=$AudioStreamPlayer
var take_damage_sfx:AudioStream=preload("res://Audio/take_damage.wav")
var coin_sfx:AudioStream=preload("res://Audio/coin.wav")

func _physics_process(delta: float) -> void:
	#gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		#double jump
	if is_on_floor():
		double_jump=2
	#jump
	if Input.is_action_just_pressed("jump") and double_jump>0:
		velocity.y = -jump_force
		double_jump-=1

	#direction
	move_input = Input.get_axis("move_left", "move_right")
	
	#move
	if move_input!=0:
		velocity.x=lerp( velocity.x, move_input * move_speed,acceleration*delta)
		
	else :
		velocity.x=lerp( velocity.x, 0.0,braking*delta)

	#send to character 
	move_and_slide()
	_manage_animation()
	
	#score display
	if global_position.y>200:
		game_over()
		
	
	
	
	
	
func _process(delta) :
	if velocity.x !=0:
		sprite.flip_h=velocity.x>0
	
func _manage_animation():
	if not is_on_floor():
		anom.play("jump")
	elif move_input!=0:
		anom.play("move")
	else :
		anom.play("idle")
		
func take_damage(amount:int):
	
	health-=amount
	OnUpdateHealth.emit(health)
	if health<=0:
		call_deferred("game_over")
	_damage_flash()
	play_sound(take_damage_sfx)
		
func game_over ():
	PlayerStats.score=0
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn" )
	
	
func add_score(amount):
	PlayerStats.score+=amount
	OnUpdateScore.emit(PlayerStats.score)
	play_sound(coin_sfx)
func _damage_flash():
	for i in 2:
		sprite.modulate=Color.RED
		await  get_tree().create_timer(0.1).timeout
		sprite.modulate=Color.WHITE
		await  get_tree().create_timer(0.1).timeout
	
func play_sound(sound: AudioStream):
	audio.stream=sound
	audio.play()
	
	
