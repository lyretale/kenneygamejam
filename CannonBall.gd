extends Area2D

export var speed := 150.0
export var damage := 10.0

onready var timer := $Timer

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
	# We load the explosion scene and instantiate it.
	#var explosion := preload("Explosion.tscn").instance()
	# Then, we place the explosion where the rocket is.
	#explosion.global_position = global_position
	# We append the explosion to the main scene's children.
	#get_tree().root.add_child(explosion)
	# And delete the rocket itself.
	queue_free()


func _on_body_entered(body: Node) -> void:
	print(body)
	if body.has_method("take_damage"):
		body.take_damage(damage)
	explode()
