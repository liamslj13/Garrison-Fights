extends CharacterBody2D

@export var speed : int = 300
@export var is_chasing : bool = false
@export var health : int = 2
var player = Global.player
var can_move : bool = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_hurt_plr : bool = true

func _ready():
	health = self.health
	is_chasing = self.is_chasing
	can_move = self.can_move
	can_hurt_plr = self.can_hurt_plr

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0 
	if can_move:
		if is_chasing:
			if (player.position.x - position.x) > 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
			if (player.position.x - position.x) > 175 or (player.position.x - position.x) < -175:
				position += (player.position - position) / speed
	repulsionexe()
	update_health()	
	move_and_slide()
	

func _on_player_in_radius_body_entered(body):
	if body == Global.player:
		player = body
		is_chasing = true
	

func _on_player_in_radius_body_exited(body):
	if body == Global.player:
		player = null
		is_chasing = false

func handle_dmg():
	if Global.is_buff:
		self.health -= 3
	else:
		self.health -= 1
	$hit.play()
	if health <= 0:
		$AnimatedSprite2D.play("death")
		$death.start()
		
func repulsionexe():
	if Global.is_repu:
		position = Vector2(self.position.x, -100)

func enemy():
	pass
	
func update_health():
	$health.value = self.health
		


func _on_death_timeout():
	Global.score += 1
	self.queue_free()


func _on_hitbox_body_entered(body):
	can_hurt_plr = true
	if body == Global.player and Global.is_attacking:
		handle_dmg()


func _on_attackcount_timeout():
	if can_hurt_plr and not Global.is_buff and not Global.invinc:
		Global.player_health -= 1


func _on_hitbox_body_exited(body):
	can_hurt_plr = false
