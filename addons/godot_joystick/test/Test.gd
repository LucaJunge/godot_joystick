extends Node3D

@onready var bug = %bug
@export var speed : float = 250

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
		var x : float = Input.get_action_strength("move_x")
		var y : float = Input.get_action_strength("move_y")
		
		bug.position += Vector2(x,y) * speed * delta
