extends CharacterBody2D


@export var speed : int = 75
@export var is_chasing : bool = false
@export var health : int = 10
var player = Global.player
var can_move : bool = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var tp = Global.player
var player_in_range : bool = false
var anim_lock = false
var can_take_dmg = false
var dead = false

func _ready():
	health = self.health
	can_move = self.can_move
	player_in_range = self.player_in_range
	anim_lock = self.anim_lock
	can_take_dmg = self.can_take_dmg
	dead = self.dead

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0 
	if can_move:
		if is_chasing:
			if (player.position.x - position.x) < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
			if (player.position.x - position.x) > 15 or (player.position.x - position.x) < -15:
				position += (player.position - position) / speed
	repulsionexe()
	update_health()
	move_and_slide()

func _on_player_in_radius_body_entered(body):
	if body == Global.player:
		player = body
		is_chasing = true
		$AnimatedSprite2D.play("walk")

func _on_player_in_radius_body_exited(body):
	if body == Global.player and not anim_lock:
		player = null
		is_chasing = false
		$AnimatedSprite2D.play("idle")
		
func handle_attack():
	anim_lock = true
	$AnimatedSprite2D.play("attack")
	$AttackTimer.start()


func _on_tp_timeout():
	if player != null and not dead:
		self.position = player.position
		handle_attack()
	else: 
		pass

func handle_dmg():
	if Global.is_buff:
		self.health -= 3
	else:
		self.health -= 1
	$hit.play()
	if health <= 0:
		dead = true
		if dead:
			can_move = false
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("death")
		$Death.start()
		
func repulsionexe():
	if Global.is_repu:
		position += Vector2(0, -100)
		Global.is_repu = false
		
func _on_attackrange_body_entered(body):
	player_in_range = true
	
func _on_attackrange_body_exited(body):
	player_in_range = false

func _on_attack_timer_timeout():
	if player_in_range and not Global.is_buff and not Global.invinc:
		Global.player_health -= 3
		print(Global.player_health)
	
func _on_hell_yeah_body_entered(body):
	if body == Global.player and Global.is_attacking:
		handle_dmg()
	can_take_dmg = true
	
func _on_hell_yeah_body_exited(body):
	can_take_dmg = false

func _on_death_timeout():
	Global.score += 4
	self.queue_free()
	
func enemy():
	pass

func update_health():
	$health.value = self.health
	
	
