extends CanvasLayer

var hearths:Array=[]
@onready var score_display: Label=$ScoreText
@onready var health_conteiner=$HearthConteiner
@onready var player=get_parent()


func _ready() -> void:
	hearths=health_conteiner.get_children()
	
	player.OnUpdateHealth.connect(_update_hearths)
	player.OnUpdateScore.connect(_update_score)


	_update_hearths(player.health)
	_update_score(PlayerStats.score)



func _update_score(score:int):
	score_display.text="Score:"+str(PlayerStats.score)
	
func _update_hearths(health:int):
	for i in len(hearths):
		hearths[i].visible=i<health
