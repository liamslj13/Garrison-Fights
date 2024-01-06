extends CharacterBody2D


@export var speed : float = 300.0
@export var jump_velocity : float = -400.0
@export var double_jump_velocity : float = -100.0
@export var health : int = 16
var is_alive : bool = true

const MAX_HEALTH : int = 8


func _ready():
	Global.player = self
	Global.player_health = self.health
	
func _exit_tree():
	Global.player = null
	

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped : bool = false
var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO



func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		has_double_jumped = false

	if is_alive:
		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				handle_jump()
			elif not has_double_jumped:
				handle_double_jump()
		elif Input.is_action_just_pressed("shoot"):
			handle_attack()
		elif Input.is_action_just_pressed("buff"):
			handle_buff()
		elif Input.is_action_just_pressed("repulse"):
			handle_repu()
		if direction:
			velocity.x = direction.x * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		direction = Input.get_vector("left", "right", "up", "down")
		move_and_slide()
		check_if_alive()
		update_animations()
		update_direction()
		player_on_ground()
		update_healthbar()
	else:
		trigger_end()

func update_animations():
	if not animation_locked:
		if direction.x != 0:
			animated_sprite.play("run")
		elif velocity.y == 0:
			animated_sprite.play("idle")
			
func handle_attack():
	Global.is_attacking = true
	animated_sprite.play("attack")
	animation_locked = true

func handle_jump():
	velocity.y = jump_velocity
	animated_sprite.play("jump")
	$jump.play()
	animation_locked = true

func handle_double_jump():
	velocity.y = double_jump_velocity
	animated_sprite.play("double jump")
	$jump.play()
	animation_locked = true
	has_double_jumped = true

func update_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true

func player_on_ground():
	if velocity.y == 0 and not Global.is_attacking:
		if not Global.is_buff and not Global.is_repu:
			if animated_sprite.animation_finished:
				animation_locked = false

func check_if_alive():
	if Global.player_health <= 0:
		is_alive = false
		animated_sprite.stop()
		animation_locked = false
	
#rest in peace to garrison
func trigger_end():
	get_tree().change_scene_to_file("res://garydies.tscn")

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "attack":
		Global.is_attacking = false
		
func update_healthbar():
	$HealthBar.value = Global.player_health
	
func handle_buff():
	if Input.is_action_just_pressed("buff"):
		if Global.can_buff:
			Global.is_buff = true
			animated_sprite.play("buff")
			$buffedaudio.play()
			$buffed.start()
			animation_locked = true
			
func handle_repu():
	if Input.is_action_just_pressed("repulse"):
		if Global.can_repu:
			Global.is_repu = true
			animated_sprite.play("repulse")
			$buffedaudio.play()
			$three.start()
			animation_locked = true
			Global.invinc = true
			
func _on_buffed_timeout():
	Global.is_buff = false

		
func _on_three_timeout():
	Global.invinc = false
	animation_locked = false
