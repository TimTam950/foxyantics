extends EnemyBase

var _seen_player: bool = false
var _can_jump: bool = false
const JUMP_VELOCITY_R = Vector2(100.0, -150.0)
const JUMP_VELOCITY_L = Vector2(-100.0, -150.0)
@onready var jump_timer: Timer = $JumpTimer

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	velocity.y += _gravity * delta
	apply_jump()
	move_and_slide()
	flip_me()
	if is_on_floor():
		velocity.x = 0.0
		animated_sprite_2d.play("idle")
	
func flip_me():
	animated_sprite_2d.flip_h = \
		_player_ref.global_position.x > global_position.x
	
			
func apply_jump() -> void:
	if !is_on_floor() or !_can_jump or !_seen_player:
		return
	velocity = JUMP_VELOCITY_R if animated_sprite_2d.flip_h else JUMP_VELOCITY_L
	_can_jump = false
	start_timer()
	animated_sprite_2d.play("jump")
	

func start_timer() -> void:
	jump_timer.wait_time = randf_range(2.0, 3.0)
	jump_timer.start()

func _on_jump_timer_timeout() -> void:
	_can_jump = true
	
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if !_seen_player:
		_seen_player = true
		start_timer()
