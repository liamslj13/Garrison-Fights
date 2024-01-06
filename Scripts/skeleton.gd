extends CharacterBody2D

@export var speed : int = 75
@export var is_chasing : bool = false
@export var health : int = 4
var player = Global.player
var can_move : bool = true
var is_attacking : bool = false
var animation_locked : bool = false
var in_radius : bool = false
var player_in_range : bool = false

func _ready():
	can_move = self.can_move
	is_attacking = self.is_attacking
	animation_locked = self.animation_locked
	in_radius = self.in_radius
	player_in_range = self.player_in_range
	
	
func _physics_process(delta):
	if can_move:
		if is_chasing:
			if (player.position.x - position.x) > 15 or (player.position.x - position.x) < -15:
				position += (player.position - position) / speed
				if (player.position.x - position.x) > 0:
					$AnimatedSprite2D.flip_h = true
				else:
					$AnimatedSprite2D.flip_h = false
	update_health()
	repulsionexe()

func _on_player_detection_body_entered(body):
	if body == Global.player:
		in_radius = true
		player = body
		is_chasing = true
		$"Attack Countdown".start()
		
func _on_player_detection_body_exited(body):
	if body == Global.player:	
		in_radius = false
		player = null
		is_chasing = false
		$"Attack Countdown".stop()
	
func _on_attack_countdown_timeout():
	can_move = false
	animation_locked = true
	$"Attack Countdown".stop()
	$AnimatedSprite2D.play("punch")
	$PunchHit.start()
	

func _on_animated_sprite_2d_animation_finished():
	can_move = true
	animation_locked = false
	$"Attack Countdown".stop()
	$AnimatedSprite2D.play("idle_move")
	
func _on_punch_area_body_entered(body):
	player_in_range = true
	if body == Global.player and Global.is_attacking:
		handle_dmg()
		
func _on_punch_area_body_exited(body):
	player_in_range = false
	
func handle_dmg():
	if Global.is_buff:
		self.health -= 3
	else:
		self.health -= 1
	$hit.play()
	if health <= 0:
		can_move = false
		$AnimatedSprite2D.play("death")
		animation_locked = true
		$Death.start()
		
func _on_punch_hit_timeout():
	if player_in_range and not Global.is_buff and not Global.invinc:
		Global.player_health -= 2
		print(Global.player_health)
		if in_radius:
			$"Attack Countdown".start()
	else:
		print(Global.player_health)
		if in_radius:
			$"Attack Countdown".start()
			
func update_health():
	$health.value = self.health
	
func repulsionexe():
	if Global.is_repu:
		position += Vector2(0, -50)

func enemy():
	pass

func _on_death_timeout():
	Global.score += 2
	self.queue_free()
