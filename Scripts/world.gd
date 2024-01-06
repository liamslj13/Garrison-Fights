extends Node2D

func _process(delta):
	update_score()
	
@onready var enemy1 = preload("res://Enemies/slime.tscn")
@onready var enemy2 = preload("res://Enemies/skeleton.tscn")
@onready var enemy3 = preload("res://cyborg.tscn")
var slime
var skeleton
var cyborg

func spawnenemy():
	slime = enemy1.instantiate()
	add_child(slime)
	skeleton = enemy2.instantiate()
	add_child(skeleton)
	cyborg = enemy3.instantiate()
	add_child(cyborg)
	cyborg.position = Vector2(randi_range(50, 600), randi_range(-100, -101))
	slime.position = Vector2(randi_range(50, 600), randi_range(-100, -101))
	skeleton.position = Vector2(randi_range(50, 600), randi_range(200, 150))

func _on_enemy_timer_timeout():
	spawnenemy()
	
func update_score():
	$ScoreCard.text = str(Global.score)


func _on_repulsion_timeout():
	$RepoCover.visible = false
	Global.can_repu = true
	$repulsiontimer.start()

func _on_buff_timeout():
	$BuffCover.visible = false
	Global.can_buff = true
	$buffcharmtime.start()
	

func _on_buffcharmtime_timeout():
	Global.can_buff = false
	$BuffCover.visible = true

func _on_repulsiontimer_timeout():
	Global.can_repu = false
	$BuffCover.visible = true

func _on_regen_timeout():
	if Global.player_health >= 16:
		Global.player_health = 16
	if Global.player_health < 16:
		Global.player_health += 1
	if  Global.player_health <= 0:
		Global.player_health = 0
		
		
