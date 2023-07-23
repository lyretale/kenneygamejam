extends Area2D

export var speed := 250.0
export var damage := 10.0

onready var timer := $Timer
onready var animation_player := $AnimationPlayer

func _ready() -> void:
	position = global_position
	connect("body_entered", self, "_on_body_entered")
	connect("area_entered", self, "_on_body_entered")
	timer.connect("timeout", self, "explode")

func _physics_process(delta: float) -> void:
	_move(delta)

func _move(delta: float) -> void:
	position += transform.x * speed * delta

func explode() -> void:	
	speed = 0.0
	animation_player.play("miss")


func _on_body_entered(body: Node) -> void:
	print(body)
	if body.has_method("take_damage"):
		body.take_damage(damage)
		speed = 0.0
		animation_player.play("hit")
