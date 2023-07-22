extends Area2D

export (float, 0.01, 1.0) var rotation_factor := 0.1
export (NodePath) var target_path

onready var target_node = get_node(target_path)
onready var start_offset = self.transform.origin - target_node.transform.origin
#onready var timer := $Timer
onready var cannon := $Sprite/Position2D
onready var sprite := $Sprite

var in_range = false

func _ready() -> void:
	# timer.connect("timeout", self, "_on_Timer_timeout")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	input_pickable = true

func _process(delta):
	self.transform.origin = target_node.transform.origin + start_offset

func _physics_process(_delta: float) -> void:
	_rotate_to_mouse()

func _rotate_to_mouse() -> void:
	var target_angle := PI / 2
	if in_range:
		target_angle = get_global_mouse_position().angle_to_point(global_position)
	sprite.rotation = lerp_angle(sprite.rotation, target_angle, rotation_factor)

func _input_event(viewport: Object, event: InputEvent, shape_idx: int) -> void:
	if (
		event is InputEventMouseButton
		and event.button_index == BUTTON_LEFT
		and event.is_pressed()
	):
		fire()

func fire():
	if not in_range:
		return
	var cannon_ball: Area2D = preload("CannonBall.tscn").instance()
	add_child(cannon_ball)
	
	cannon_ball.global_transform = cannon.global_transform
	

func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	in_range = true

func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	in_range = false
