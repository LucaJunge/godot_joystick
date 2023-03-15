extends Control

@onready var bug = %bug
@onready var hslider = %HSlider
@onready var vslider = %VSlider
@onready var label = %Label
@export var speed : float = 250

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
		var x : float = Input.get_action_strength("move_x")
		var y : float = Input.get_action_strength("move_y")
		
		bug.position += Vector2(x,y) * speed * delta
		
		hslider.value = x
		vslider.value = - y
		
		label.text = "X: %.2f   Y: %.2f" % [x, y]
