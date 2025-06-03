class_name Player extends CharacterBody2D

@export var fell_off_y: float = 1200.0

const GRAVITY : float = 690.0
const JUMP_SPEED: float = -270.0
const RUN_SPEED: float = 120.0
const MAX_FALL: float = 350.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Label

func _enter_tree() -> void:
	add_to_group(Constants.PLAYER_GROUP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_SPEED
	velocity.x = Input.get_axis("left", "right") * RUN_SPEED
	if not is_equal_approx(velocity.x, 0.0):
		sprite_2d.flip_h = velocity.x < 0
		
	velocity.y = clampf(velocity.y, JUMP_SPEED, MAX_FALL)
	move_and_slide()
	update_debug_label()
	fallen_off()

func update_debug_label():
	var ds: String = ""
	ds += "Floor:%s\n" % [is_on_floor()]
	ds += "V:%.1f,%.1f\n" % [velocity.x, velocity.y]
	ds += "P:%.1f,%.1f" % [global_position.x, global_position.y]
	label.text = ds
	
func fallen_off() -> void:
	if global_position.y > fell_off_y:
		queue_free()
